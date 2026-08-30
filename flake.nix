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
							function install-components --description='Install a component of the program' --inherit-variable=src
							    set --local -- source_dir {$argv[1]}
							    set --local -- vendor_dir {$argv[2]}
							    for source in "$src"{$source_dir}/**.fish
							        set --local -- output_path {$source} # Same output path in case of no root directory
							        set --query --local -- src && set --local -- output_path (string split --fields=2 --max=1 -- "$src" {$source}) # Remove root directory from the output path
							        install -D --mode=644 -- {$source} "$out"/"$remote"share/fish/vendor_{$vendor_dir}.d/(string split --fields=2 --max=1 -- {$source_dir} {$output_path} | string replace --all -- / _ | string replace -- {,_}load-nixpkg-script_)
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
