---
comments: true
icon: lucide/house
description: Home Page
---

# Home
Create Nix developments environments for Fish projects compatible with Direnv

## Description
*fish-nixenv* is an extenion of [direnv][direnv] that adds support for Fish shell hooks, and standardizes some universal hooks that work directly with Nix packages.

## Scope
To do it's job, this Fish plugin utilizes the environment variables set and unset by [direnv][direnv], as defined by the development shells of a flake.  
That means, fish-nixenv isn't a Flake input, or a built-in Bash shell hook that can be added to a Nix flake per-project, but rather like Direnv—a program that the user needs to locally install in their host system for it to work.

The repository's flake provides a `default` package that you can install with Nix, and start using it with [compatible repositories](https://github.com/topics/fish-nixenv/ "GitHub topic")


[direnv]: https://direnv.net "direnv is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory."
