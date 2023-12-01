{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.lakeroad-yosys = {
    type = "github";
    owner = "uwsampl";
    repo = "yosys";
    ref = "gussmith23/lakeroad-backend";
    flake = false;
  };
  outputs = { self, nixpkgs, lakeroad-yosys }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      yosys1 = pkgs.yosys.overrideAttrs (finalAttrs: previousAttrs: {
        pname = "lakeroad-" + previousAttrs.pname;
        src = lakeroad-yosys;
        # preBuild = ''
        #   		chmod -R u+w .
        #       		make config-${
        #           if pkgs.stdenv.cc.isClang or false then "clang" else "gcc"
        #         }
        #   	'';
        doCheck = false;
        buildInputs = previousAttrs.buildInputs ++ [ pkgs.boost ];
      });
    in {
      devShells."${system}".default = pkgs.mkShell {
        inputsFrom = [ yosys1 ];

        buildInputs = with pkgs; [ cargo rustc verilog racket yosys1 ];
      };
      packages."${system}".lakeroad-yosys = yosys1;

    };
  # organist.flake.outputsFromNickel ./. inputs {};}
}
