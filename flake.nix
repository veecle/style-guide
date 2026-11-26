{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    make-shell = {
      url = "github:nicknovitski/make-shell";
      inputs.flake-compat.follows = "";
    };

    veecle-utilities = {
      url = "github:veecle/utilities";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.make-shell.follows = "make-shell";
    };

    # Used by the Claude review action, which builds it from the style guide's checkout so the reviewed PR cannot
    # influence which version runs. Its inputs are deliberately not overridden, so it matches what lynk's CI pushes to
    # the `lynk.cachix.org` binary cache.
    lynk.url = "github:vE5li/lynk";
  };

  outputs = inputs @ {
    flake-parts,
    make-shell,
    veecle-utilities,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        make-shell.flakeModules.default
        # TODO: switch to `default` once the Markdown files are migrated to `mdslw` formatting.
        veecle-utilities.flakeModules.nix-lint
      ];

      _module.args.root = ./.;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        packages.lynk = inputs'.lynk.packages.default;

        make-shells.default.packages = [pkgs.mdbook];
      };
    };
}
