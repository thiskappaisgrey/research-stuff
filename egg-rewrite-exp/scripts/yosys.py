# import subprocess

# creates a yosys script string to be used by "just"

import argparse
from pathlib import Path

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                    prog='ProgramName',
                    description='What the program does',
                    epilog='Text at the bottom of help')
    parser.add_argument('test_path')           
    parser.add_argument('out_path')           
    parser.add_argument('mod_name')           
    parser.add_argument('cell_lib')           
    parser.add_argument('cell_impl')           
    
    args = parser.parse_args()

    test_path = Path(args.test_path)
    mod_name = args.mod_name
    cell_lib = args.cell_lib
    cell_impl = args.cell_impl
    out_path = Path(args.out_path)
    outv = out_path / Path(test_path.stem + "_synth.v")
    outegg = out_path /  Path(test_path.stem + ".egg")

    yosys_script1 = f'''
read_verilog {test_path};
prep -top {mod_name};
# elaborate design hierarchy
hierarchy -check -top {mod_name};


# mapping flip-flops to mycells.lib
dfflibmap -liberty {cell_lib};
techmap;  # opt
# mapping logic to mycells.lib
abc -liberty {cell_lib};
# write into an "abc" techmap design 
# then read + flatten to get a design with XORs
read_verilog {cell_impl};
flatten;
write_verilog {outv};
write_lakeroad {outegg};'''

    print(yosys_script1)
    # def proc("")
