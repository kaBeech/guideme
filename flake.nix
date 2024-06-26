{
  description = "A flake for starting a GuideMe development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    guideme-init = import ./scripts/guideme-init.nix { inherit pkgs; };
  in
  {
    devShells.${system}.default = 
      pkgs.mkShell 
        {
          buildInputs = with pkgs; [
            elixir
            erlang
            inotify-tools
            guideme-init
          ];

          shellHook = ''
            cat ./scripts/dev-shell.txt
          '';
        };
  };
}
