---
comments: true
icon: lucide/fishing-hook
description: Generic information on hooks, their implementation, and how they are defined
---

# Hooks
Hooks are Fish functions that that may be executed with a trigger: entering, exiting, and changing a Fish plugin repository.

## Defining data for the shell
The information needed by these hooks is transfered to the shell via environment variables.  
Each hook asks only for a single environment variable. The environment variable might contain different sort of data depending on the hook the variable is accepted by.

To define a hook, make your development shell derivation include the environment variable wanted by the hook, and set it to the value you want to pass to the hook. The hook will then be able to read the value of the environment variable and use it as needed.
```nix { title="Fish plugin flake template", hl_lines="28 29 35 36" }
{
	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = [ <system1>, <system2>, … ]; # (1)!
			perSystem = { self', inputs', pkgs, lib, system, ... }: {
				packages = {
					default =  pkgs.stdenvNoCC.mkDerivation {
						name = "<package-name>"; # (2)!
						inherit system;
						src = ./.;
						# (3)!
						fixupPhase = ''
							substituteInPlace $out/share/fish/vendor_functions.d/<primary-function>.fish --replace-fail \
								PATHS-TO-DEPENDENCY-FUNCTIONS '{${inputs'.dependency1.packages.default},${inputs'.dependency2.packages.default}}/share/fish/vendor_functions.d'
							substituteInPlace $out/share/fish/vendor_functions.d/<primary-function>.fish --replace-fail \
								'/dev/null # shell-startup directories' ${inputs'.dependency1.packages.default}/share/fish/vendor_conf.d
						''; # (4)!
					};
				};
				devShells.default = pkgs.mkShellNoCC {
					# (5)!

					<hookvar_name_foo> = <hookvar_value_foo>;
					<hookvar_name_bar> = <hookvar_value_bar>;
					… # (6)!

					shellHooks = ''
						# Other universal unrelated script executed externally in Bash

						export <dynamic_hookvar_name_foo>="<dynamic_hookvar_value_foo>";
						export <dynamic_hookvar_name_bar>="<dynamic_hookvar_value_bar>";
							…
					'' # (7)!
				};
			};
		};
}
```

1.  The list of systems the Fish plugin package supports.  
    **Example**: `[ "x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin" ]`
2. The name of the Fish plugin package package
3.  Add different phases in order to execute prepare the package.  
    **Example Phases**: `buildPhase`, `installPhase`, etc
4.  Make dependency Fish plugins available to your Fish program
5.  Other unrelated configuration for the development environment
6.  Definitions for environment variables as asked for by the Fish shell hooks
7.  For some niche case, you might want to define a dynamic hook that isn't possible with Nix alone.  
    In that case, you can instead export the variable using the Bash shell `shellHooks`

## Implementation
These hooks are triggered when the environment variables defined in the development shell derivation are modified by Direnv.  
The trigger is made possible by the `--on-variable` flag available to loaded Fish functions (hence the functions reside in `conf.d/`).  
Each hook uses the `--on-variable` flag to listen on the environment variable it is interested in. When the environment variable is modified, the hook is executed.
