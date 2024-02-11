{

  Sources = {
        src | String,
        deps | Array String,
        mod_name | String
  },
  CellLib = {
        src | String,
        def | String,
  },
 
  Schema = 
  {
       sources | Array Sources,
       top | String,
       yosys_script_base | String,
       yosys_path | String | optional,
       outdir | String,
       cell_lib | CellLib
  },

}
