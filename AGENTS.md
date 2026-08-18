# AGENTS.md

This file provides guidance to coding agents (Claude Code, Codex) when working with code in this repository. `CLAUDE.md`
is a symlink to this file, so edit this one.

## What this is

Personal cross-platform dotfiles for macOS (Darwin) and Linux (Omarchy/Arch). There is no build, no test suite, and no
linter. The whole thing is bash plus symlinks.

`lib/nix.conf` and `lib/secrets.ejson` are referenced by nothing in the repo. Leave them alone unless Muto says
otherwise; unreferenced is not the same as unused when secrets are in play.

## Commands

`./apply` is the only entry point. It dispatches on `uname -s` and runs every executable directly under `darwin/`
(macOS) or `omarchy/` (Linux), in filename order. It is idempotent, so re-run it after any change.

Run it from the repo root. Link targets are built from `$(pwd)`, so applying from anywhere else points every symlink at
a path that does not exist.

To verify a change, run `./apply`, read the `gum log` output, and check the symlinks it claims to have made. There is
nothing else to run.

Hard dependencies of the scripts themselves: `gum` (all logging), plus `jq` and `yq` (agent config rendering). On macOS
they come from the Brewfile.

## Layout and the symlink model

`config/` maps onto `~/.config` and `bin/` onto `~/.local/bin`, one for one. Adding a file to either is all it takes;
nothing registers it anywhere.

Two functions in `lib/utils.sh` carry this:

- `link_directory_recursively` links per file, never per directory. That is deliberate: a directory like
  `~/.config/mise` can hold both repo-managed files and files the tool writes itself.
- `prune_dotfiles_links` is its counterpart and must run before relinking. Renaming or deleting a file here leaves a
  dangling link in `$HOME` otherwise. It only removes dangling links pointing back into this repo.

Platform entry points are `darwin/setup` and `omarchy/0*.sh`. Anything shared between them belongs in `lib/`.

## Agent configuration

`agents/` is the single source for both Claude Code and Codex config, rendered by `lib/agents.sh`. Read the comments in
that file before changing it; they cover the non-obvious parts.

- `agents/base/*.md` are instruction fragments, concatenated in filename order.
- `agents/rules/*.md` are topic rules with optional frontmatter, rendered once per agent. A rule with `paths` globs
  becomes a Claude rules file, and a model-invoked `rule-<name>` skill for Codex, which has no glob-scoped instruction
  channel of its own. A rule without `paths` is always-on: a Claude rules file, and an `AGENTS.md` fragment for Codex.
- `agents/skills/` is shared by both agents verbatim.
- `agents/hooks/` scripts are shared too. Both agents pass the same envelope (`tool_name`, `tool_input`,
  `tool_response`) and read back the same `hookSpecificOutput`. Only the wiring differs: Claude in `settings.json`,
  Codex in `hooks.json`.
- `agents/claude/` and `agents/codex/` hold per-agent wiring only.

`.build/` is generated and gitignored. Never edit it, and never edit the rendered files under `~/.claude` or `~/.codex`.
Those are symlinks into `.build`, so an edit either lands in generated output that the next `./apply` overwrites, or
silently modifies this repo.

Plugins are left to each agent's own manager, but neither is declarative on its own, so `lib/agents.sh` reconciles both.
Claude's `enabledPlugins` only enables an already-installed plugin, so `sync_claude_plugins` installs whatever is
missing. Codex reads `agents/codex/plugins.tsv`.

## Conventions

- Commits follow Conventional Commits. The history predates that decision (`3049072` is the first commit to follow it),
  so do not infer the format from `git log`.
- `git add .` is forbidden. Stage files individually.
- Every script starts with `set -euo pipefail`.
- Log with `gum log --level info|warn|error`, not `echo`.
