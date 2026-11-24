{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Used by the Claude review action, which builds it from the style guide's checkout so the reviewed PR cannot
    # influence which version runs.
    lynk = {
      url = "github:vE5li/lynk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    lynk,
  }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
  in
  {
    packages.lynk = lynk.packages.${system}.default;

    devShells.default = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.mdbook
      ];
    };
  });
}
