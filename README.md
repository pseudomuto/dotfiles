# My Dotfiles

Personal cross-platform dotfiles for macOS (Darwin) and Linux (Omarchy/Arch), on ARM64 and x86_64. Bash and symlinks,
no framework.

```sh
git clone https://github.com/pseudomuto/dotfiles.git
cd dotfiles
./apply
```

`./apply` picks the platform, installs packages (Homebrew on macOS, Omarchy on Arch), links `config/` into `~/.config`
and `bin/` into `~/.local/bin`, pins tool versions with [mise], and renders coding agent config from `agents/`. It is
idempotent, so re-run it whenever something here changes.

This has evolved over the years to a little more than just dotfiles. If you're of the opinion these should be dirt
simple, well...

![](https://cloud.githubusercontent.com/assets/64263/19022286/f792b660-88a2-11e6-8133-c9e11555f05a.jpg)

[mise]: https://mise.jdx.dev
