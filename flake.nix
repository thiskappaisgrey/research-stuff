{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.nickel.url = "github:tweag/nickel";
  nixConfig = {
    extra-substituters = [ "https://tweag-nickel.cachix.org" ];
    extra-trusted-public-keys = [
      "tweag-nickel.cachix.org-1:GIthuiK4LRgnW64ALYEoioVUQBWs0jexyoYVeLDBwRA="
    ];
  };

  outputs = { self, nixpkgs, nickel, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # TODO: Using a dev version of yosys and have ot recomp a lot
      # so it doesn't make sense to install using Nix

      pyrtl = pkgs.python3Packages.callPackage ./pyrtl.nix { };

    in {

      devShells."${system}".default = pkgs.mkShell {

        # For testing yosys stuff
        inputsFrom = [ pkgs.yosys ];

        buildInputs = with pkgs; [
          cargo
          rustc
          verilog
          sv-lang
          svls
          svlint

          verilator

          # For testing yosys stuff
          lit
          llvmPackages.bintools-unwrapped
          yosys-synlig

          just

          # For developing yosys
          ccls
          bear
          clang-tools
          boost
          clang
          yosys
          self.inputs.nickel.packages."${system}".nickel-lang-cli
          self.inputs.nickel.packages."${system}".lsp-nls

        ];
      };
      # packages."${system}".lakeroad-yosys = yosys1;

    };
  # organist.flake.outputsFromNickel ./. inputs {};}
}
