{
  Source = {
    src | String,
    deps | Array String,
    mod_name | String
  },
  CellLib = {
    vsrc | String,
    lib | String,
  },

  YosysConfig =
    # the passes to run and the order to run in
    # TODO: Have more granularity for passes and the order to run in..
    # TODO: For each pass create - map to a yosys script
    {
      # The source of the module
      src | Source,
      # What cell library to use?
      cell_lib | CellLib,
      passes | Array Pass,
      synth_passes | Array SynthPass,
      outdir | String
    },

  Pass = [| 'techmap, 'flatten, 'pmuxtree, 'proc |],
  # a "SynthPass" is a pass that outputs a file
  SynthPass = {
    synthpass | [| 'verilog, 'egglog |],
    out | String
  },

  RustSource = {
    source | Array String,
    yosys_script | String
  },
  # the schema being passed to the rust code, which then runs yosys
  # technically doesn't need to be rust at all tbh..
  RustSchema = {
    sources | Array RustSource,
    outdir | String,
    yosys_path | String | optional # yosys scripts
  }
}
