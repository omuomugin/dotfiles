import { View, div, svg } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, agents, theme, run, window, keys, exec, home, watchFolder } from "herdr";

// my-status: the shipped workspace-status plus Claude Code's rate limits.
// claude/statusline.sh (dotfiles) writes the latest `rate_limits` it was given to
// ~/.cache/claude-usage/rate_limits.json; this watches that folder and shows them.
const usageDir = () => `${home()}/.cache/claude-usage`;

export default class WorkspaceStatus extends View {
  init(_props, cx) {
    this.limits = null; // { five_hour?: {used_percentage, resets_at}, seven_day?: ... }
    cx.spawn(async (cx) => {
      const dir = usageDir();
      try { await exec("mkdir", ["-p", dir]); } catch {}
      await this.loadLimits(cx);
      for (;;) {
        await watchFolder(dir);
        await this.loadLimits(cx);
      }
    });
    // Re-render now and then so a window that passed its resets_at disappears.
    cx.spawn(async (cx) => {
      for (;;) { await cx.sleep(60_000); cx.notify(); }
    });
  }

  async loadLimits(cx) {
    try {
      const r = await exec("cat", [`${usageDir()}/rate_limits.json`]);
      this.limits = r.code === 0 ? JSON.parse(r.stdout) : null;
    } catch {
      this.limits = null; // missing or half-written: show nothing rather than stale junk
    }
    cx.notify();
  }

  // "5h 23% ↻14:30" / "7d 41% ↻11/5"; null once the window has reset.
  limit(name, w, t, longReset) {
    if (!w || typeof w.used_percentage !== "number") return null;
    if (w.resets_at && w.resets_at * 1000 <= Date.now()) return null;
    const pct = Math.round(w.used_percentage);
    const color = pct >= 80 ? t.ansi1 : pct >= 50 ? t.ansi3 : t.muted;
    const at = w.resets_at ? new Date(w.resets_at * 1000) : null;
    const pad = (n) => String(n).padStart(2, "0");
    const reset = !at ? "" : longReset ? ` ↻${at.getMonth() + 1}/${at.getDate()}` : ` ↻${pad(at.getHours())}:${pad(at.getMinutes())}`;
    return h_flex().gap(4).items_center()
      .child(div().text_color(t.dim).child(name))
      .child(div().text_color(color).child(`${pct}%`))
      .when(Boolean(reset), (el) => el.child(div().text_color(t.dim).child(reset)));
  }

  usage(t) {
    const l = this.limits;
    const parts = [this.limit("5h", l?.five_hour, t, false), this.limit("7d", l?.seven_day, t, true)].filter(Boolean);
    if (!parts.length) return null;
    return parts.reduce((row, p) => row.child(p), h_flex().id("claude-usage").gap(10).items_center());
  }
  // The palette key as actually bound, not a hardcoded one; without a
  // binding the hint stays useful ("commands") instead of lying.
  hint(t) {
    const mac = window()?.platform === "macos";
    const mod = { cmd: mac ? "⌘" : "Ctrl+", ctrl: mac ? "⌃" : "Ctrl+", shift: mac ? "⇧" : "Shift+", alt: mac ? "⌥" : "Alt+", option: mac ? "⌥" : "Alt+" };
    const b = keys().find((k) => k.section === "global" && k.action === "app.palette");
    const parts = b && b.keys.endsWith("--") ? [...b.keys.slice(0, -2).split("-"), "-"] : b?.keys.split("-");
    const key = parts && parts.map((p) => mod[p.toLowerCase()] ?? p.toUpperCase()).join("");
    return key ? `${key}  commands` : "commands";
  }

  render() {
    const t = theme();
    const space = spaces().find(s => s.active);
    const list = agents();
    const needs = list.filter(a => a.status === "blocked").length;
    const usage = this.usage(t);
    const label = (icon, text) => h_flex().gap(6).items_center().child(svg(`mods/workspace-chrome/${icon}.svg`).size(13)).child(text);
    return h_flex().size_full().px(14).gap(16).items_center().bg(t.chrome).border_t(1).border_color(t.border).text_size(11.8).text_color(t.muted)
      .child(label(space?.machine ? "server" : "monitor", space?.machine ?? "This computer"))
      .when(Boolean(space?.branch), el => el.child(label("branch", space.branch)))
      .child(h_flex().gap(6).items_center().child(div().size(6).rounded(3).bg(t.dim)).child(`${list.length} agents`)
        .when(needs > 0, el => el.child(div().text_color(t.blocked).child(`· ${needs} needs you`))))
      .when(Boolean(usage), el => el.child(usage))
      .child(div().flex_1())
      .child(div().id("palette").text_color(t.dim).on_click(() => run("app.palette")).child(this.hint(t)));
  }
}
