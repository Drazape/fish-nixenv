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
						installPhase = ''
								install -D --mode=644 -- "$src"/conf.d/_load-nixpkg-scripts.fish "$out"/share/fish/vendor_conf.d/_load-nixpkg-scripts.fish
						'';
					};
				};
			};
		};
}
