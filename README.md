# Dotfiles

So...this has evolved to a little bit more than dotfiles over the years. At this point, this repo represents dotfiles,
as well as applications and configuration.

If you think this is a little overboard...

![](https://cloud.githubusercontent.com/assets/64263/19022286/f792b660-88a2-11e6-8133-c9e11555f05a.jpg)

## Usage

`bin/setup` is used to apply all of the changes to the target system. Each _change_ is represented by a delta (file) in 
_lib/deltas_. These delta files each implement (at least) two functions:

* `applied` - Determines whether or not this delta has been applied already
* `apply` - Performs the necessary steps for applying the delta

Delta scripts can also define options and validate them (see _lib/deltas/ruby.sh_ for an example).

### How to Run

* `bin/setup` - Ensures `brew` is installed (if running on OSX), and symlinks all files in `./files` to `~/`
* `bin/setup -a` - Same as above, but also applies a bunch of other deltas (see _lib/phases.sh_)

![](https://cloud.githubusercontent.com/assets/4748863/17540335/4a508d5e-5e83-11e6-9838-c350e817ba3a.png)

### Initial Setup

You can always, just clone the repo and run `bin/setup`.

You can also `eval "$(curl -fsSL https://raw.github.com/pseudomuto/dotfiles/master/bootstrap.sh)"` on a fresh machine.
This will download (not clone, git might not be installed yet) this repo to `~/dotfiles` and run `bin/setup` (just
dotfiles...in case it's a shared system or something)

## Deltas are Idempotent

When you run `bin/setup`, the deltas are called via `bin/apply <delta> [<delta_args>]`. E.g. `bin/apply git -v 2.9.2`. 

The apply script will check if the delta has already been applied and if so, will notify the setup script that the delta
has already been applied (nothing to do). Otherwise, it will call `apply` and if successful, will call `applied` to
verify that the change has actually occurred.

