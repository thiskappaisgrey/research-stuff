{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {self, nixpkgs, clash}:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
      {
        devShells."${system}".default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            verilog
            racket
            # z3
            yosys
         ];
        }; 
      };
    # organist.flake.outputsFromNickel ./. inputs {};}
}
