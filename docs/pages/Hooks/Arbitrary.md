---
comments: true
icon: lucide/shield-question-mark
description: The lowest level hook
---

# Arbitrary
The lowest level hook with arbitrary power and the most boilerplate.

| Environment Variable | Value Type |
| :------------------: | :--------: |
|  `FISH_DIRENV_HOOKS` |  File path |

## Value
The value of the `FISH_DIRENV_HOOKS` environment variable is a file path to a Fish script.  
This Fish script is sourced when we enter a directory, and comes equipped with some optional barebones abstractions that can be used to manage more triggers automatically.
!!! note "Custom Hook"
    For more advanced use cases, it may even [ignore the opt-in trigger abstraction](#without-abstraction){data-preview} - and turn the script into it's own hook!

## Definition
It is typically defined statically (without `shellHooks`) in the Nix development shell attributes set.

The value needs to be a file path to the Fish script containing the hook; it doesn't matter how you define it.
!!! tip "Fish plugin flake template"
    The [Fish plugin flake template](./index.md#defining-data-for-the-shell){data-preview} provides a complete example of how to define a Fish plugin Nixpkg, and a *fish-nixenv* development environment for it - in a flake
2 common ways to do that in Nix is:
### External file path
Simply specify the value to the path of the expected Fish script in the current repository using the [path file type of Nix](https://nix.dev/manual/nix/2.35/language/types.html#type-path "An immutable, finite-length sequence of bytes starting with `/`, representing a POSIX-style, canonical file system path")

### Written via Nix
You can also define the Fish script path by writing the file in-place with the Nix function [`builtins.toFile`](https://nix.dev/manual/nix/2.34/language/builtins#builtins-toFile "Store a string in a file in the Nix store - and return its path").

## Usage
The following sections show how to use the hook according to your usecase.  
Each use only modifies how the Fish script is written.
### Without Abstraction
The abstractions the hook provides are opt-in. You can simply ignore them if they don't meet your usecase.

In this case, the hook is simply a Fish script that is sourced when we enter a directory. You can do whatever you want in this script.

This is the simplest (and also sometimes the most complex case, depending on your needs) of the hook scripts.  
It is nothing more than a shellInit script that you use, without any additional conveniences of fish-nixenv (or its abstractions).

This is best suited for:

- changes that should, for some reason, last forever—throughout the session.
- changes that permanently modify the system itself.
- and the only practical one, changes that only need to be triggered when entering the directory.

### With abstraction
These are conveniences the hook provides - that enable you to set and check global variables to determine the operation of the trigger.

#### Enter
Mostly the same as the “[Without Abstraction](#without-abstraction)” case, but you need to do some setup for also triggering on Exits.  

When leaving the Fish project's directory, The hook triggers a function defined while sourcing the script on *Enter*.  
The source script is to set a global variable (according to the type of exit) to the function name that should be called.

#### Exit
Once the setup is complete with the Enter script, next, you can define the function that will be called on exit.  
Edit the source Fish script such that it sets the global variable `_fish_plugin_remover` to the name of the function that should be called on exit.

The function is simply a raw Fish script that is executed when exiting the Fish plugin's repository.
```fish
…
set --global -- _fish_plugin_remover <a-unique-function-name>
function {$_fish_plugin_remover}
    … # (1)!
end
```

1. The raw Fish script you'd like to execute when leaving the directory.

##### Change
In niche cases, you may want the exit behavior to differ from exits when changing to different Fish plugin repositories.

!!! info "Defaults to [Remover](#exit)"
    By default, the change-exit behavior defaults to the same function as used for “normal exit.”

The procedure is the same as for the [remover](#exit), but the global variable `_fish_plugin_changer` is used instead of `_fish_plugin_remover`.
```fish
…
set --global -- _fish_plugin_changer <a-unique-function-name>
function {$_fish_plugin_changer}
    … # (1)!
end
```

1. The raw Fish script you'd like to execute when switching the working directory to another Fish plugin project.
