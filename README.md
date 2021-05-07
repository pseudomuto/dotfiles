# Dotfiles

So...this has evolved to a little bit more than dotfiles over the years. At this point, this repo represents dotfiles,
as well as applications and configuration.

If you think this is a little overboard...

![](https://cloud.githubusercontent.com/assets/64263/19022286/f792b660-88a2-11e6-8133-c9e11555f05a.jpg)

## Usage

* `./setup` should be run before anything else. This will ensure homebrew is installed, along with a recent version of
ruby. - _only needs to be run the very first time_
* `exe/dotfiles link` - link all files in _./files_ to equivalents under the home directory
* `exe/dotfiles packages` - install all packages list in _~/.config/dotfiles/config_
* `exe/dotfiles configure` - Add app/system configuration (default shell, vim plugins, etc.)

There's a shorthand for running link, packages, and configure in sequence: `exe/dotfiles apply`.

All commands support `-n, --dry-run` to see what _would_ happen without applying any changes.

<img width="1918" alt="Sample Run" src="https://user-images.githubusercontent.com/4748863/117486778-1200be00-af38-11eb-9ae5-faf7dfc64b9f.png">
