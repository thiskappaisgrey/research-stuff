{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  # inputs.lakeroad-yosys = {
  #   type = "github";
  #   owner = "uwsampl";
  #   repo = "yosys";
  #   ref = "gussmith23/lakeroad-backend";
  #   flake = false;
  # };
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # TODO: Using a dev version of yosys and have ot recomp a lot
      # so it doesn't make sense to install using Nix

      # yosys1 = pkgs.yosys.overrideAttrs (finalAttrs: previousAttrs: {
      #   pname = "lakeroad-" + previousAttrs.pname;
      #   src = lakeroad-yosys;
      #   # preBuild = ''
      #   #   		chmod -R u+w .
      #   #       		make config-${
      #   #           if pkgs.stdenv.cc.isClang or false then "clang" else "gcc"
      #   #         }
      #   #   	'';
      #   doCheck = false;
      #   buildInputs = previousAttrs.buildInputs ++ [ pkgs.boost ];
      # });

      pyrtl = pkgs.python3Packages.callPackage ./pyrtl.nix { };

    in {
      devShells."${system}".default = pkgs.mkShell {

        # For testing yosys stuff
        inputsFrom = [ pkgs.yosys ];

        buildInputs = with pkgs; [
          cargo
          rustc
          verilog
          racket
          sv-lang
          svls
          svlint
          verilator
          # For testing yosys stuff
          lit
          llvmPackages.bintools-unwrapped
          yosys-synlig
          (python3.withPackages (p: with p; [ cocotb pyrtl ]))

          just

          # For developing yosys
          ccls
          bear
          clang-tools
          boost
          clang

        ];
      };
      # packages."${system}".lakeroad-yosys = yosys1;

    };
  # organist.flake.outputsFromNickel ./. inputs {};}
}
