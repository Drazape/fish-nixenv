---
comments: true
icon: lucide/snowflake
description: A high-level hook for a Fish plugin env from a Nixpkg
---

# Nixpkg
A high-level hook for creating a development environment from a Fish plugin Nixpkg, essentially, hot-loading it.

| Environment Variable |    Value Type   |
| :------------------: | :-------------: |
|     `FISH_NIXPKG`    |  Directory path |

## Value
Path to a built Nixpkg of the Fish plugin you want to load in your environment.  
!!! note "Package Compatibility"
    This Fish plugin package is one that would work when a user installs it in a Nix environment.

The hook autoloads the following components the package may have:
| component | path | load method | unloads |
| :-------: | :--: | :---------: | :-----: |
| shell-initialization scripts | `share/fish/vendor_conf.d/` | recursive `source` | ❌ |
| functions | `share/fish/vendor_functions.d/` | prepending `fish_function_path` | ✅ |
| completions | `share/fish/vendor_completions.d/` | prepending `fish_complete_path` | ✅ |

## Definition
It is typically defined statically (without `shellHooks`) in the Nix development shell attributes set.

Providing it with the package path is fairly straightforward in a Nix flake; you'd probably want to give it the path to the package you defined in the `packages` attrset of the same flake like so:
```nix
… # (1)!

        pkgs.mkShellNoCC {
          FISH_NIXPKG = self'.packages.default;
        };
…
```

1. See the [Fish plugin flake template](./index.md#defining-data-for-the-shell){data-preview} for the complete format on defining a Fish plugin Nixpkg in a flake - and use it for a fish-nixenv development shell.

!!! note "*flake-parts* `self'` parameter"
This example uses [flake-parts](https://flake.parts/ "flake-parts provides the options that represent standard flake attributes and establishes a way of working with `system`")'s `self'` parameter to make it easier. You can apply identically to any other framework (or raw flake)

Once this trivial setup is complete, the hook will automagically hotload the whole Fish plugin that was built.
