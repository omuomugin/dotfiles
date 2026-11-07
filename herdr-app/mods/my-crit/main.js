// 実行中の crit セッション一覧。クリックでブラウザのレビュー画面を開く。
// 前回開いたあとに review.json の updated_at が進んでいれば「更新あり」のドットを出す。

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { exec, home, theme, shared, setShared, layout, props, openOverlay, closeOverlay, notify, readTextFile } from "herdr";
import * as fs from "fs/promises";

const POLL_MS = 5000;
const SEEN_KEY = "crit.seen";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

// サイドバーが細いときは他のサイドバー mod と同じく簡易表示にする
const narrow = () => (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160;

const base = (p) => (p ?? "").replace(/\/+$/, "").split("/").pop() ?? "";

function duration(ms) {
  const m = Math.max(0, Math.floor(ms / 60000));
  if (m < 60) return `${m}m`;
  const h = Math.floor(m / 60);
  if (h < 24) return `${h}h`;
  return `${Math.floor(h / 24)}d`;
}

function unresolvedCount(review) {
  const open = (cs) => (cs ?? []).filter((c) => c.resolved !== true).length;
  let n = open(review?.review_comments);
  for (const f of Object.values(review?.files ?? {})) n += open(f?.comments);
  return n;
}

// セッション id ごとの種別とタイトル。md の見出しと ps は1回だけ取る
const metaCache = new Map();

// fs/promises はホーム配下しか読めないので、scratchpad（/private/tmp）の plan も読める readTextFile を使う
async function firstHeading(path) {
  try {
    const text = await readTextFile(path);
    if (text == null) return null;
    const line = text.split("\n").find((l) => /^#\s+\S/.test(l));
    return line ? line.replace(/^#\s+/, "").trim() : null;
  } catch {
    return null;
  }
}

async function commandLine(pid) {
  try {
    const r = await exec("ps", ["-o", "command=", "-p", String(pid)]);
    return r.code === 0 ? r.stdout.trim() : "";
  } catch {
    return "";
  }
}

// Plan: md の最初の見出し / File: ファイル名 / Code・PR: ブランチ名
async function metaOf(id, s) {
  if (metaCache.has(id)) return metaCache.get(id);
  const args = s.args ?? [];
  const md = args.find((a) => /\.md$/i.test(a));
  let meta;
  if (md) {
    // crit を相対パスで起動すると args も相対のまま記録されるので cwd 基準で解決する
    const path = md.startsWith("/") ? md : `${s.cwd}/${md}`;
    meta = { kind: "plan", label: "Plan", title: (await firstHeading(path)) ?? base(md).replace(/\.md$/i, "") };
  } else if (args.length > 0) {
    meta = { kind: "file", label: "File", title: args.map(base).join(", ") };
  } else {
    const pr = (await commandLine(s.pid)).match(/--pr[ =](\S+)/)?.[1];
    const num = pr?.match(/(\d+)\/?$/)?.[1];
    meta = {
      kind: pr ? "pr" : "code",
      label: pr ? (num ? `PR #${num}` : "PR") : "Code",
      title: s.branch || base(s.cwd),
    };
  }
  metaCache.set(id, meta);
  return meta;
}

async function alive(pid) {
  if (!Number.isInteger(pid) || pid <= 0) return false;
  try {
    const r = await exec("kill", ["-0", String(pid)]);
    return r.code === 0;
  } catch {
    return false;
  }
}

async function readJson(path) {
  try {
    return JSON.parse(await fs.readFile(path, "utf8"));
  } catch {
    return null;
  }
}

async function loadSessions() {
  const dir = `${home()}/.crit/sessions`;
  let names = [];
  try {
    names = (await fs.readdir(dir)).filter((n) => n.endsWith(".json"));
  } catch {
    return [];
  }
  const out = [];
  for (const name of names) {
    const s = await readJson(`${dir}/${name}`);
    if (!s || !(await alive(s.pid))) continue;
    const id = name.replace(/\.json$/, "");
    const review = s.review_path ? await readJson(`${s.review_path}/review.json`) : null;
    const meta = await metaOf(id, s);
    out.push({
      id,
      pid: s.pid,
      url: `http://${s.host || "127.0.0.1"}:${s.port}`,
      ...meta,
      repo: base(s.cwd),
      branch: s.branch ?? "",
      startedAt: Date.parse(s.started_at) || 0,
      updatedAt: review?.updated_at ?? null,
      round: review?.review_round ?? null,
      unresolved: unresolvedCount(review),
    });
  }
  // 新しく始まったものを上に
  out.sort((a, b) => b.startedAt - a.startedAt);
  return out;
}

const RELOAD_KEY = "crit.reload";

// pid がまだ crit のデーモンか（pid の再利用で別プロセスを止めないため）
async function isCritDaemon(pid) {
  return /\bcrit\b.*\b_serve\b/.test(await commandLine(pid));
}

// SIGTERM → 1秒待って残っていれば SIGKILL → セッションファイルが残っていれば消す
async function stopSession(stop) {
  const file = `${home()}/.crit/sessions/${stop.id}.json`;
  if (await isCritDaemon(stop.pid)) {
    await exec("kill", [String(stop.pid)]);
    await exec("sleep", ["1"]);
    if (await isCritDaemon(stop.pid)) await exec("kill", ["-9", String(stop.pid)]);
    if (await isCritDaemon(stop.pid)) throw new Error(`pid ${stop.pid} が終了しませんでした`);
  }
  if (await fs.exists(file)) await fs.unlink(file);
}

const seenMap = () => {
  const v = shared(SEEN_KEY);
  return v && typeof v === "object" ? v : {};
};

// 一度も開いていない、または前回開いたあとに updated_at が進んだ
function hasUpdate(s) {
  const seen = seenMap()[s.id];
  if (!seen) return true;
  if (!s.updatedAt) return false;
  return Date.parse(s.updatedAt) > Date.parse(seen);
}

export default class Crit extends View {
  init(_props, cx) {
    // 確認ダイアログとして開かれたコピーは一覧を読まない
    if (props()?.stop) {
      this.handle = cx.focus_handle();
      this.handle.focus();
      this.stopping = false;
      return;
    }
    this.sessions = [];
    this.loaded = false;
    this.hovered = null;
    this.reloadSeen = shared(RELOAD_KEY);
    this.refresh(cx);
    cx.timer.every(POLL_MS, (cx) => this.refresh(cx));
  }

  confirmStop(s) {
    openOverlay({
      mod: "my-crit",
      kind: "dialog",
      width: 380,
      height: 170,
      props: { stop: { id: s.id, pid: s.pid, title: s.title, label: s.label } },
    });
  }

  doStop(cx) {
    if (this.stopping) return;
    this.stopping = true;
    cx.notify();
    const p = props();
    cx.spawn(async () => {
      try {
        await stopSession(p.stop);
        notify({ title: "crit セッションを終了しました", body: `${p.stop.label} ${p.stop.title}`, level: "success", timeout: 3000 });
      } catch (e) {
        notify({ title: "crit セッションを終了できませんでした", body: String(e?.message ?? e), level: "error" });
      } finally {
        // 一覧側のコピーに読み直しを知らせる
        setShared(RELOAD_KEY, Date.now());
        closeOverlay(p.overlay);
      }
    });
  }

  dialog() {
    const t = theme();
    const p = props();
    const button = (id, label, bg, fg, onClick) =>
      h_flex()
        .id(id)
        .h(30)
        .px(14)
        .items_center()
        .rounded(8)
        .border_1()
        .border_color(id === "no" ? t.input : bg)
        .bg(bg)
        .text_color(fg)
        .cursor_pointer()
        .hover((s) => s.opacity(0.88))
        .on_click(onClick)
        .child(label);
    return v_flex()
      .id("crit-stop")
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        if (e.key === "enter") this.doStop(cx);
        else if (e.key === "escape") closeOverlay(p.overlay);
        else return;
        cx.stop_propagation();
      })
      .size_full()
      .min_h(0)
      .p(18)
      .gap(10)
      .bg(t.popover)
      .text_size(13)
      .child(div().font_semibold().text_color(t.foreground).child("crit セッションを終了しますか？"))
      .child(div().truncate().text_color(t.foreground).child(`${p.stop.label}  ${p.stop.title}`))
      .child(div().text_size(12).text_color(t.dim).child("レビュー待ちのエージェントがいる場合、その crit コマンドも終了します。"))
      .child(
        h_flex()
          .flex_1()
          .justify_end()
          .items_end()
          .gap(8)
          .child(button("no", "キャンセル", t.popover, t.foreground, () => closeOverlay(p.overlay)))
          .child(button("yes", this.stopping ? "終了中…" : "終了", t.blocked, t.solid_foreground ?? "#ffffff", (_e, cx) => this.doStop(cx))),
      );
  }

  refresh(cx) {
    if (this.loading) return;
    this.loading = true;
    cx.spawn(async (cx) => {
      try {
        this.sessions = await loadSessions();
        this.loaded = true;
        cx.notify();
      } finally {
        this.loading = false;
      }
    });
  }

  open(s, cx) {
    exec("open", [s.url]).catch(() => {});
    const seen = { ...seenMap() };
    // 開いた時点の updated_at を記録する（無ければ今の時刻）
    seen[s.id] = s.updatedAt ?? new Date().toISOString();
    // 止まったセッションの記録は捨てる
    const live = new Set(this.sessions.map((x) => x.id));
    for (const k of Object.keys(seen)) if (!live.has(k)) delete seen[k];
    setShared(SEEN_KEY, seen);
    cx.notify();
  }

  render(cx) {
    if (props()?.stop) return this.dialog();
    const t = theme();
    const collapsed = narrow();

    // ダイアログ側で終了したら、ポーリングを待たずに読み直す
    const reload = shared(RELOAD_KEY);
    if (reload !== this.reloadSeen) {
      this.reloadSeen = reload;
      this.refresh(cx);
    }

    const stopButton = (s) =>
      div()
        .id(`crit-stop-${s.id}`)
        .flex_none()
        .size(18)
        .rounded(5)
        .flex()
        .items_center()
        .justify_center()
        .text_size(12)
        .text_color(t.dim)
        .hover((st) => st.bg(t.blocked + "26").text_color(t.blocked))
        .tooltip("セッションを終了")
        .on_click((_e, cx) => {
          cx.stop_propagation();
          this.confirmStop(s);
        })
        .child("×");
    const now = Date.now();

    const dot = (on) =>
      div()
        .size(7)
        .flex_none()
        .rounded(4)
        .bg(on ? t.accent : "#00000000");

    const badge = (n) =>
      div()
        .flex_none()
        .px(6)
        .h(18)
        .rounded(5)
        .bg(t.blocked + "26")
        .text_size(10.5)
        .font_semibold()
        .text_color(t.blocked)
        .flex()
        .items_center()
        .child(String(n));

    const row = (s) => {
      const updated = hasUpdate(s);
      if (collapsed) {
        return h_flex()
          .id(`crit-${s.id}`)
          .h(28)
          .flex_none()
          .justify_center()
          .items_center()
          .gap(4)
          .rounded(8)
          .cursor_pointer()
          .hover((st) => st.bg(t.hover))
          .tooltip(`${s.label}: ${s.title}`)
          .on_click((_e, cx) => this.open(s, cx))
          .child(dot(updated))
          .when(s.unresolved > 0, (el) => el.child(badge(s.unresolved)))
          .when(s.unresolved === 0, (el) => el.child(div().text_size(11).text_color(t.dim).child("C")));
      }
      // Code / PR はブランチが1行目に出ているので2行目には出さない
      const showBranch = s.kind === "plan" || s.kind === "file";
      const meta = [s.repo, showBranch ? s.branch : null, duration(now - s.startedAt), s.round ? `round ${s.round}` : null]
        .filter(Boolean)
        .join(" · ");
      const label = div()
        .flex_none()
        .px(5)
        .h(16)
        .rounded(4)
        .bg(t.raised)
        .text_size(10)
        .font_medium()
        .text_color(t.muted)
        .flex()
        .items_center()
        .child(s.label);
      return h_flex()
        .id(`crit-${s.id}`)
        .px(8)
        .py(5)
        .flex_none()
        .rounded(8)
        .items_center()
        .gap(9)
        .cursor_pointer()
        .hover((st) => st.bg(t.hover))
        .tooltip(`${s.title}\n${s.url}`)
        .on_hover((on, cx) => {
          if (on) this.hovered = s.id;
          else if (this.hovered === s.id) this.hovered = null;
          cx.notify();
        })
        .on_click((_e, cx) => this.open(s, cx))
        .child(dot(updated))
        .child(
          v_flex()
            .flex_1()
            .min_w(0)
            .child(
              h_flex()
                .min_w(0)
                .gap(6)
                .items_center()
                .child(label)
                .child(
                  div()
                    .flex_1()
                    .min_w(0)
                    .truncate()
                    .text_color(updated ? t.foreground : t.muted)
                    .when(updated, (el) => el.font_medium())
                    .child(s.title),
                ),
            )
            .child(div().truncate().text_size(11).text_color(t.dim).child(meta)),
        )
        .when(this.hovered === s.id, (el) => el.child(stopButton(s)))
        .when(this.hovered !== s.id && s.unresolved > 0, (el) => el.child(badge(s.unresolved)));
    };

    return v_flex()
      .size_full()
      .min_h(0)
      .bg(t.chrome)
      .border_t(1)
      .border_color(t.border)
      .text_size(13)
      .when(!collapsed, (el) =>
        el.child(
          h_flex()
            .px(16)
            .h(41)
            .pt(14)
            .pb(5)
            .flex_none()
            .items_center()
            .justify_between()
            .child(div().text_size(11.5).font_medium().text_color(t.dim).child("Crit"))
            .when(this.sessions.length > 0, (el) => el.child(div().text_size(11).text_color(t.dim).child(String(this.sessions.length)))),
        ),
      )
      .when(this.loaded && this.sessions.length === 0 && !collapsed, (el) =>
        el.child(div().px(16).text_size(12).text_color(t.dim).child("No crit sessions")),
      )
      .child(
        v_flex()
          .id("crit-list")
          .flex_1()
          .min_h(0)
          .px(collapsed ? 0 : 8)
          .overflow_y_scrollbar()
          .children(this.sessions.map(row)),
      );
  }
}
