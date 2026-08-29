Create Nix developments environments for Fish projects compatible with Direnv

# The automation included
One can create a Nix development environment for Fish plugins by executing Fish with `--init-command`.
The flag can be used to provide a script that sets the script lookup paths to ones from the Nix package.
Now, once we are done, we can finally use `nix develop` each time in the directory.

While this approach works, it particularly leaves a few issues unaddressed—all the issues solved by [Direnv][direnv]:
1. **Manual**: We need to manually run `nix develop` each time we enter the repository
2. **Environment Loss**: Any modifications (manual `source`s, functions, variables, abbreviations, completions, bindings, Fish plugin data for the session, …) we added to the previous session are lost
3. **Overhead**: Your whole interactive shell would have to re-initialized: reading shell initialization scripts, sourcing lookup functions, Fish plugins
4. **Overlap**: If you don't use `exec` with `nix develop`, you'll have another shell beneath your current shell that you'll have to close

> [!TIP]
> [Discover packages that are using fish-nixenv](https://github.com/topics/fish-nixenv/ "GitHub topic")

# [Direnv][direnv] compatibility
If these issue are already solved by [Direnv][direnv], why do we need this project?  
For Fish projects, we need to make the included functions, completions, and shellInit scripts available to the current shell session.
(to allow us to use the project version in the current directory.)  
This is not possible with `direnv` alone, as it only sets environment variables, runs the `shellHooks` in a separate Bash shell, and does not provide a way to modify the internal Fish environment.

With fish-nixenv, we can use `direnv` to automatically load the Nix development environment for Fish projects, while also ensuring that all Fish functions and completions are indexable, and shell initialization scripts sourced, by the current Fish session.

# Usage
Once you have setted up direnv with to use Nix, in your shell definition, simply set the environment variable `FISH_NIXPKG` to the the path to your Fish plugin's package.
```nix
{
  …

	outputs = inputs@{ flake-parts, ... }:
	…
				packages = {
					default = pkgs.stdenvNoCC.mkDerivation {
						src = ./.;
						…
					};
				};
				devShells.default = pkgs.mkShellNoCC { FISH_NIXPKG = self'.packages.default; }; # set the environment variable `FISH_NIXPKG` to the path of the Fish plugin's package
			};
		};
}
```
For users who'd have installed this direnv extension can now use your Fish project directly in the current shell session, without having to run `nix develop` each time they enter the directory.


[direnv]: https://direnv.net "direnv is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory."
