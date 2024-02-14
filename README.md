dotfiles for omuomugin

```
# for the first time
sh setup.sh 

# just link the config files
sh ./scripts/link_dotfiles.sh
```

## Karabiner-Elements
copy `karabiner.json` to config directory.
see also https://karabiner-elements.pqrs.org/docs/manual/operation/export/

## Raycast
import `xxxx.raycast` from raycast setting.

## Warning
dotfiles are symbolic linked through `ghq` workspace


e.g.
```
.aliases -> $HOME/workspace/github.com/omuomugin/dotfiles/.aliases
```