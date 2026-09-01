---
comments: true
icon: lucide/blocks
description: Why you need fish-nixenv, and how it extends with Direnv.
---

# Direnv compatibility
Why you need fish-nixenv, and how it extends with Direnv.

## Standalone direnv
Besides the [additional benefits of fish-nixenv over plain direnv](./Benefits.md#original){data-preview}, you *need* fish-nixenv for Fish plugins since it's impossible to edit the internal Fish environment (manual `source`s, functions, variables, abbreviations, completions, bindings, Fish plugin data for the session, …) with direnv alone.

The “external environment”—environment variables are the only thing that direnv can modify for a Fish shell session.  
The modification can either be done using static environment in the shell itself, or dynaimcally by spawning a new Bash shell process to run the `shellHooks` in.
These `shellHooks` in question are limited to running arbitrary operations upon entering the directory, and modifying environment variables.

## Direnv integration
Since we can already use `nix develop` to achieve what we want, what we're looking for with fish-nixenv is the ability to leverage the [benefits of Direnv](./Benefits.md#inherited){data-preview}.

Since environment variables is the only thing that direnv can modify, we use just that to get all the information we need to hook current Fish plugin repository for our development environment.

When fish-nixenv is installed (making each session load with the shell initialization scripts of fish-nixenv), we use the environment variable `FISH_DIRENV_HOOKS` to reveal a file path to the Nix store where the hooks for the current Fish plugin repository are stored (both initialization and termination).

!!! note "Other environment variables from universal hooks"
    There are universal hook abstractions that eliminate the boilerplate from frequently repeated hooks throughout Fish projects.  
    These addons may accept their own environment variables.
