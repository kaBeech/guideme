{
  description = "A flake for starting a GuideMe development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default = 
      pkgs.mkShell 
        {
          buildInputs = with pkgs; [
            elixir
            erlang
            inotify-tools
          ];

          shellHook = ''
            echo "Hello, world!"
            mix deps.get
            mix deps.compile
            mix ecto.setup
          '';
        };
  };
}