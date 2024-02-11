// TODO need to figure out
//
mod rewrites;

use std::fs;
use std::io::Write;
use std::path::Path;

use crate::rewrites::*;
use clap::Parser;
use egglog::EGraph;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// The library definition you want to find
    lib_filename: String,
    /// The module where you are looking for
    mod_filename: Option<String>,
    /// The rewrites rules to apply
    #[arg(long)]
    rewrites: Vec<String>,
}

fn main() {
    let args = Args::parse();
    println!("The rewrite libs we are applying is: {:?}", args.rewrites);
    //  ---- REWRITE STUFF ----
    // Here, we have to clone because the hashmap references will be invalidated
    // when I mutate it by evaling an expression
    let s = RewriteBuilder::new(&args.lib_filename);
    let rewrite = s.into_rewrite();
    println!("{rewrite}");
    s.to_svg();

    // "mod_filename" is the file name of the module to find half_adders
    if let Some(name) = args.mod_filename {
        println!("Match on: {name}");
        // 1. build up a new egraph
        let mut s1 = RewriteBuilder::new(&name);
        // TODO: Need to figure out
        //
        let rewrite = true;
        let deoptimize = true;
        let rewrite_rule = if rewrite { "(saturate rewrites)" } else { "" };
        let deoptimize_rule = if deoptimize {
            "(saturate deoptimize)"
        } else {
            ""
        };

        let rule = format!("(run-schedule (repeat 50 {deoptimize_rule} ))\n (run-schedule (repeat 50 {rewrite_rule} ))");

        // for each decode wire
        let r = s.into_rewrite();
        // let e = s1.extract_rule();
        let mut file = fs::File::create("rewrite.egg").unwrap();
        let _ = file.write(&r.clone().into_bytes());

        s1.run_expr(&r, false);
        s1.run_expr(&rule, true);
        let ex = s1.extracted_egraph();
        if let Some(ex) = ex {
            println!("{ex}");
            let mut egraph = EGraph::default();
            let lang_lib = include_str!("../egglog_src/lang.egg");
            let rewrite_lib = include_str!("../egglog_src/rewrite.egg");
            egraph.parse_and_run_program(lang_lib).unwrap();
            egraph.parse_and_run_program(rewrite_lib).unwrap();
            egraph.parse_and_run_program(&s.into_mod()).unwrap();

            egraph.parse_and_run_program(&ex).unwrap();
            let path = Path::new("extracted.egg").with_extension("svg");
            let serialized = &egraph.serialize_for_graphviz(true);
            let svg_path = Path::new(&path).with_extension("svg");
            let path_str = svg_path.to_str().unwrap();
            println!("Print svg to: {path_str}");
            serialized.to_svg_file(svg_path).unwrap();
        }
        // s1.run_expr(&e, true);

        println!("Ran schedule");
        s1.to_svg();
    }
    // Actually - instead of using an egglog style rewrite rule..
    // Can I just directly, in the rust code, do the search for half_adders..?
}
