{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.lakeroad-yosys = {
      type = "github";
      owner = "uwsampl";
      repo = "yosys";
      ref = "gussmith23/lakeroad-backend";
      flake = false;
  };
  outputs = {self, nixpkgs, lakeroad-yosys }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      yosys1 = pkgs.yosys.overrideAttrs (finalAttrs: previousAttrs: {
        pname = "lakeroad-" + previousAttrs.pname;
        src = lakeroad-yosys;
        buildInputs = previousAttrs.buildInputs ++ [ pkgs.boost ];
      });
    in
      {
        devShells."${system}".default = pkgs.mkShell {
          inputsFrom = [ yosys1 ];

          buildInputs = with pkgs; [
            cargo
            rustc
            verilog
            racket
            yosys
         ];
        };
        packages."${system}".lakeroad-yosys = yosys1;

      };
    # organist.flake.outputsFromNickel ./. inputs {};}
}
