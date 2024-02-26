let { create_rustsource, def_yosys_config, .. } = import "./lib.ncl"in
let { RustSchema, .. } = import "./schema.ncl" in
{
  sources = [
    (create_rustsource
      (
        def_yosys_config
          {
            src = "./alu.sv",
            deps = [],
            mod_name = "alu"
          }
      ))
  ],
  yosys_path = "/home/thanawat/projects/share/research-proj/lakeroad-yosys/yosys",
  outdir = "./out"
} | RustSchema
