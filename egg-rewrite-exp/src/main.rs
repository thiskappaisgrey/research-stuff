// TODO need to figure out
//
mod rewrites;

use std::fmt::Write;
use std::path::Path;

use crate::rewrites::*;
use clap::Parser;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct RewriteConfig {
    rewrite_lib: String, // the lang is compiled in b/c the rewrite is dependent on it
    libs: Vec<String>,
    rule_out_file: String,
}

// TODO: Use serde instead to get the configs
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// The library definition you want to find
    config_file: String,
    /// The module where you are looking for
    mod_filename: Option<String>,
    /// The rewrites rules to apply
    #[arg(short)]
    svg: bool,
    #[arg(short)]
    no_pickle: bool,
}

fn main() {
    let args = Args::parse();
    let st = std::fs::read_to_string(&args.config_file).unwrap();
    let c: serde_json::Result<RewriteConfig> = serde_json::from_str(&st);
    match c {
        Err(e) => {
            println!("Error deserializing: {e}");
        }
        Ok(cfg) => {
            //  ---- REWRITE STUFF ----
            // Here, we have to clone because the hashmap references will be invalidated
            // when I mutate it by evaling an expression
            let rewrite_lib = &cfg.rewrite_lib;
            let out_file = Path::new(&cfg.rule_out_file);
            let mut out = String::new();
            // out_file.
            //
            for l in cfg.libs {
                let s = RewriteBuilder::new(&l, rewrite_lib);
                if args.svg {
                    s.to_svg();
                }
                let r = s.into_rewrite();
                let _ = out.write_str(&r);
            }

            let _ = std::fs::write(out_file, out);

            // "mod_filename" is the file name of the module to find half_adders
            // if let Some(name) = args.mod_filename {
            // println!("Match on: {name}");
            // // 1. build up a new egraph
            // let mut s1 = RewriteBuilder::new(&name, rewrite_lib);
            // // TODO: Need to figure out
            // //
            // let rewrite = args.rewrite;
            // let deoptimize = args.deop;
            // let rewrite_rule = if rewrite { "(saturate rewrites)" } else { "" };
            // let deoptimize_rule = if deoptimize {
            //     "(saturate deoptimize)"
            // } else {
            //     ""
            // };
            // let niters = args.niters;
            //
            // let rule =
            //     format!("(run-schedule (repeat {niters} {deoptimize_rule} {rewrite_rule} ))");
            //
            // // for each decode wire
            // let r = s.into_rewrite();
            // // let e = s1.extract_rule();
            // let mut file = fs::File::create("rewrite.egg").unwrap();
            // let _ = file.write(&r.clone().into_bytes());
            //
            // s1.run_expr(&r, false);
            // s1.run_expr(&rule, true);
            // let ex = s1.extracted_egraph();
            // if let Some(ex) = ex {
            //     println!("{ex}");
            //     let mut egraph = EGraph::default();
            //     let lang_lib = include_str!("../egglog_src/lang.egg");
            //     let rewrite_lib = include_str!("../egglog_src/rewrite.egg");
            //     egraph.parse_and_run_program(lang_lib).unwrap();
            //     egraph.parse_and_run_program(rewrite_lib).unwrap();
            //     egraph.parse_and_run_program(&s.into_mod()).unwrap();
            //
            //     egraph.parse_and_run_program(&ex).unwrap();
            //     let path = Path::new("extracted.egg").with_extension("svg");
            //     let serialized = &egraph.serialize_for_graphviz(true);
            //     let svg_path = Path::new(&path).with_extension("svg");
            //     let path_str = svg_path.to_str().unwrap();
            //     println!("Print svg to: {path_str}");
            //     serialized.to_svg_file(svg_path).unwrap();
            // }
            // // s1.run_expr(&e, true);
            //
            // println!("Ran schedule");
            // s1.to_svg();
            // }
        }
    }
}
