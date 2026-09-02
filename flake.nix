{
	description = "Allow making direnv devShells for Fish projects";

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
							function install-components --description='Install a component of the program'
								set --local -- source_dir ${./.}/{$argv[1]}
								set --local -- vendor_dir {$argv[2]}
								for source in {$source_dir}/**.fish
									set --local -- filename (
										string split --fields=2 --max=1 -- {$source_dir}/ {$source} |
										string replace --all -- / _
									)
									test {$vendor_dir} = functions && set --local -- filename _{$filename}
									install -D --mode=644 -- {$source} {$out}/share/fish/vendor_{$vendor_dir}.d/{$filename}
								end
							end

							install-components functions{,}
							install-components conf{.d,}
						'';
					};
				};
			};
		};
}
