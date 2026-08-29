{
	description = "Allow making direnv devshells for Fish projects";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
			perSystem = { self', pkgs, system, ... }: {
				packages = let pkgName = "fish-nixenv"; in {
					default = self'.packages.${pkgName};
					${pkgName} = pkgs.stdenvNoCC.mkDerivation {
						name = pkgName;
						inherit system;
						src = ./.;
						installPhase = pkgs.writers.writeFish "install_fish-nixenv" ''
							for dir in functions completions
								for source in ${./.}/{$dir}/**.fish
									install -D --mode=644 -- {$source} "$out"/share/fish/vendor_{$dir}.d/(string split --fields=2 --max=1 -- {$dir}/ (string split --fields=2 --max=1 -- ${./.} {$source}) | string replace --all -- / _)
								end
							end
						'';
					};
				};
			};
		};
}
