Create Nix developments environments for Fish projects compatible with Direnv

> [!TIP]
> ### Detailed [documentation](https://drazape.github.io/fish-nixenv/ "GitHub Pages: Zensical documentation")
> Everything below (and more: usage, implementation, etc) is covered extensively in the main documentation.

# The automation included
Though you can create Fish devshells without direnv (or fish-nixenv) by working around `shellHooks` and executing `fish` with `--init-command`. Then runnning `nix develop` each time we enter the directory.

While this approach works, it particularly leaves a few inconveniences unaddressed—the conveniences provided by [Direnv][direnv], that are useless for Fish projects without fish-nixenv:
1. **Manual**: We need to manually run `nix develop` each time we enter the repository
2. **Environment Loss**: Any modifications (manual `source`s, functions, variables, abbreviations, completions, bindings, Fish plugin data for the session, …) we added to the previous session are lost
3. **Overhead**: Your whole interactive shell would have to re-initialized: reading shell initialization scripts, sourcing lookup functions, Fish plugins
4. **Overlap**: If you don't use `exec` with `nix develop`, you'll have another shell beneath your current shell that you'll have to close

> [!TIP]
> [Discover packages that are using fish-nixenv](https://github.com/topics/fish-nixenv/ "GitHub topic")

# [Direnv][direnv] compatibility
If these issue are already solved by [Direnv][direnv], why do we need this project?  
For Fish projects, we need to make the included functions, completions, and shellInit scripts available to the current shell session, allowing us to use the plugin version in the current directory—the most common, thus abstracted use case (though abritrary hooks can be defined to do much more).
This is not possible with `direnv` alone, as it only sets environment variables, runs the `shellHooks` in a separate Bash shell, and does not provide a way to modify the internal Fish environment.

With fish-nixenv, we can use `direnv` to automatically load the Nix development environment for Fish projects, while also ensuring that all Fish functions and completions are indexable, and shell initialization scripts sourced, by the current Fish session.

# Installation
You can install the `default` package of this flake using Nix on all Linux distributions alike.

## NixOS
1. Add the input to your `flake.nix`
```nix
inputs = {
	…
	chromaleon = {
		type="github"; owner="drazape"; repo="ChromaLeon-flake";
		inputs.nixpkgs.follows = "nixpkgs"; # optional
	};
	…
};
…
```

2. Simply install the `default` package in your system environment from the added input in a module.
```nix
environment.systemPackages = [
	…
	inputs.chromaleon.packages.${pkgs.stdenvNoCC.hostPlatform.system}.default
	…
];
```


[direnv]: https://direnv.net "direnv is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory."
