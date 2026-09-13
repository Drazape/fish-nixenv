---
comments: true
icon: lucide/star-plus
description: Benefits of fish-nixenv
---

# Benefits
Because fish-nixenv is simply a Direnv extension, it inherits all the benefits of Direnv, while also providing additional benefits for Fish users.

## Inherited
One can create a Nix development environment for Fish plugins by executing Fish with [`--init-command`](https://fishshell.com/docs/current/cmds/fish.html "Fish Shell documentation on the flag").
The flag can be used to desired execute shell hooks
Now, after we are done, we can finally use `nix develop` each time we enter the directory.

While this approach works, it particularly leaves a few inconveniences unaddressed—the conveniences provided by [Direnv][direnv] that Fish projects can't benefit from without fish-nixenv:
### 1. Manual
We need to manually run `nix develop` each time we enter the repository.  
Direnv resolves this problem by automatically loading the Nix development environment the moment we enter the directory, and unloading it when we leave the directory.
### 2. Environment Loss
Any modifications (manual `source` calls, functions, variables, abbreviations, completions, bindings, Fish plugin data for the session, …) we added to the previous session are lost.
These modifications are preserved by Direnv. This is because it only modifies the environment variables of the current shell session, and does not spawn a new shell.
The preservation of previous shell environment can be valuable when testing a Fish plugin — because these includes all the modifications we made before entering the directory.  
These modifications could be useful while testing the plugin, and make quitting the directory more convenient — because returning to the previous shell environment would no longer involve exiting the current one.
### 3. Overhead
Your whole interactive shell would have to re-initialized, including other Fish plugins, personal shell initialization scripts, and sourcing on-demand lookup functions.
While with fish-nixenv, this overhead is avoided by hooks to modify and restore the environment accordingly to if we're in the repository's directory, computing only the changes.
### 4. Overlap
If you don't use `exec` with `nix develop`, you'll have another shell beneath your current shell that you'll have to close. And when you do use `exec`, the previous environment is lost.

## Original
Features exclusive to fish-nixenv, unavailable in direnv
### 1. Fish-shell hooks
You can make changes to the internal Fish shell environment (in contrast to only being able to set environment variables).
### 2. Dual Hooks
You can run shell hooks for both entering and exiting the directory.
### 3. Abstraction
For common tasks, there are [universal hooks](../Hooks/Nixpkg.md){data-preview} which you can use with different environment variables that do all the heavy lifting for you, so you don't have to write your own shell hooks.
!!! note "Independent Implementation"
    For various reasons (briefly: readability, maintainability, and extensibility), these abstactions are implemented entirely independently of the hooks:

    - **Hook launching**: By separating the functions triggering on different environment variables, we don't have to manually check for what function is set.
    - **Unshareable**: The code for each of the function is fairly trivial and unique. Sharing logic only makes it more complicated, unmodular, and less extensible.
    - **Not Addons**: Due to the nature of the hooks (file sourcing to avoid environment pollution), the specialized abstractions can't simply be hooked onto.
### 4. [Uses standard flake](./Direnv-Compatibility.md){data-preview}
To declare fish-nixenv hooks, you don't have to add any external inputs (or use any custom functions to declare the shell) in order to use fish-nixenv.
