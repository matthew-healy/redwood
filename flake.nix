{
  description = "redwood is a ruby wrapper for the cedar policy language.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    , naersk
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk { };

        # currently just build the rust lib. have tried to package the gem
        # but i can't get bundle install to work - i suspect the gemspec isn't
        # being copied into the nix store but also i have no idea what i'm
        # doing so who knows.
        buildRedwood = args:
          let
            defaultArgs = {
              src = ./.;

              cargoTestCommands = prev:
                prev
                ++ [
                  ''cargo $cargo_options clippy -- -Dwarnings''
                ];

              override = prev: prev // {
                buildInputs = [
                  pkgs.rustPlatform.bindgenHook
                ];

                nativeBuildInputs = prev.nativeBuildInputs ++ (with pkgs; [
                  clippy
                  ruby
                ]);
              };
            };
          in
          naersk'.buildPackage (defaultArgs // args);

        preCommitHook = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            nixpkgs-fmt.enable = true;
            rustfmt.enable = true;
          };
        };
      in
      {
        apps.default = buildRedwood { };

        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${preCommitHook.shellHook}
          '';

          buildInputs = [
            pkgs.rustPlatform.bindgenHook
          ];

          nativeBuildInputs = with pkgs; [
            rustc
            cargo

            clippy
            rust-analyzer
            rustfmt

            ruby
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
