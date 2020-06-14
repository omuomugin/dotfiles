dotfiles for omuomugin

```
# for the first time
sh setup.sh 

# just link the config files
sh ./scripts/link_dotfiles.sh
```

## Warning
dotfiles are symbolic linked through `ghq` workspace


e.g.
```
.aliases -> $HOME/workspace/github.com/omuomugin/dotfiles/.aliases
```