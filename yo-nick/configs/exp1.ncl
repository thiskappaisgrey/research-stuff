let { Schema, .. } = import "schema.ncl" in
{
                sources =  [{
                        mod_name = "top",
                        src =  "./tests/experiments/top.sv",
                        deps = [
                            "./tests/experiments/alu.sv",
                            "./tests/experiments/decoder.sv"
                        ]
                }],
                top = "top",
                yosys_script_base = m%"
                  techmap; opt;
                  flatten;

                "%,
                outdir = "./out", 
                cell_lib = {
                        src = "./yosys_lib/mycells.lib", 
                        def = "./yosys_lib/mycells.v"
                }

} | Schema
