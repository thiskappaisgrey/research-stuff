# Generate a yosys script using configuration
# Given a config (i.e. the source + what yosys passes to run) - we can generate a yosys script
# TODO: For each dep - read teh verilog
let { Source, CellLib, YosysConfig, Pass, SynthPass, RustSource, .. } = import "schema.ncl" in
{
  create_yosys | YosysConfig -> String = fun config =>
      # putting this as a "let" makes the function "private"
      # TODO: maybe there's a way to not have things be "opt"
      let create_pass | Pass -> String = (
          fun pass =>
            (
              pass
              |> match {
                'techmap => "techmap; opt; dfflibmap -liberty %{config.cell_lib.lib};\nabc -liberty %{config.cell_lib.lib};\nread_verilog %{config.cell_lib.vsrc};\n",
                'flatten => "flatten; opt",
                'pmuxtree => "pmuxtree; opt",
                'proc => "proc; opt"
              }
            )
        )
        in
      let create_passes | Array Pass -> String = fun passes => std.array.fold_left (fun acc value => let p = create_pass value in "%{acc}%{p}\n") "" passes in
      let create_synth_pass | SynthPass -> String = fun pass =>
          (
            pass.synthpass
            |> match {
              'verilog => "write_verilog %{config.outdir}/%{pass.out}",
              'egglog => "write_lakeroad %{config.outdir}/%{pass.out}"
            }
          )
        in
      let create_synth_passes | Array SynthPass -> String = fun passes => std.array.fold_left (fun acc value => let p = create_synth_pass value in "%{acc}%{p}\n") "" passes in
      let deps = std.array.fold_left (fun a b => "%{a}read_verilog -sv %{b};\n") "" config.src.deps in
      let passes = create_passes config.passes in
      let synth_passes = create_synth_passes config.synth_passes in
      m%"
%{deps}
read_verilog -sv %{config.src.src};
prep -top %{config.src.mod_name};
hierarchy -check -top %{config.src.mod_name};
%{passes}
%{synth_passes}
"%,

  def_yosys_config | Source -> YosysConfig = fun src' =>
      {
        src = src',
        passes = [
          'techmap,
          'flatten,
          'flatten
        ],
        cell_lib = {
          lib = "mycells.lib",
          vsrc = "mycells.v"
        },
        outdir = "out",
        synth_passes = [
          {
            synthpass = 'verilog,
            out = "synth.v"
          },
          {
            synthpass = 'egglog,
            out = "%{src'.mod_name}.egg"
          }
        ]
      },
  create_rustsource | YosysConfig -> RustSource = fun ycfg =>
      {
        source = [ycfg.src.src] @ ycfg.src.deps,
        yosys_script = create_yosys ycfg
      }
}
