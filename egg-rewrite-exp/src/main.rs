// TODO need to figure out
use anyhow::Result;
use clap::Parser;
use egglog::{
    ast::Expr::*,
    ast::{parse::ExprParser, Expr, Symbol},
    ArcSort, EGraph,
    ExtractReport::*,
    TermDag, Value,
};
use env_logger::Env;
use log::{info, trace, warn};
use std::{
    collections::{HashMap, HashSet},
    fmt::{write, Write},
    fs,
    io::Write as OtherWrite,
    path::Path,
    process::exit,
};

struct RewriteBuilder {
    e: EGraph,
    name: String,
    i_wires: HashSet<String>,
    out_map: Vec<(String, Expr)>,
    src: String,
    path: String,
}

impl RewriteBuilder {
    pub fn new(name: &str) -> Self {
        let file = Path::new(&name);
        let st = std::fs::read_to_string(file).unwrap();
        let mut egraph = EGraph::default();

        // Add stuff to the library
        let lang_lib = include_str!("../egglog_src/lang.egg");
        let rewrite_lib = include_str!("../egglog_src/rewrite.egg");
        egraph.parse_and_run_program(lang_lib).unwrap();
        egraph.parse_and_run_program(rewrite_lib).unwrap();
        match egraph.parse_and_run_program(&st) {
            Ok(_msgs) => {
                println!("Running egraph {} succeed", file.to_str().unwrap());
            }
            Err(err) => {
                println!(
                    "Running egraph {} failed with error: {err}",
                    file.to_str().unwrap()
                );
                exit(1);
            }
        };

        let o_wires: Vec<_> = egraph
            .global_bindings
            .keys()
            .filter(|p| Self::match_symbol(p, "o_").unwrap())
            .cloned()
            .collect();

        let mut i_wires: HashSet<String> = HashSet::new();
        let out_map: Vec<(String, Expr)> = o_wires
            .clone()
            .into_iter()
            .map(|wire| {
                println!("Extracting {wire}");
                let (sort, value) = egraph
                    .eval_expr(&egglog::ast::Expr::Var(wire.into()), None, true)
                    .unwrap();

                let expr = RewriteBuilder::extract_value(&egraph, &value, &sort);
                let inputs = RewriteBuilder::get_input_wires(&expr);
                let rep_expr = RewriteBuilder::replace_in_expr(&expr, &inputs);
                inputs.values().for_each(|input| {
                    i_wires.insert(input.to_string());
                });
                (wire.to_string(), rep_expr.clone())
            })
            .collect();

        RewriteBuilder {
            e: egraph,
            name: file.file_stem().unwrap().to_str().unwrap().to_string(),
            i_wires,
            out_map,
            src: st,
            path: name.to_owned(),
        }
    }
    pub fn into_mod(&self) -> String {
        let name_upper = self.name.to_uppercase();
        let mut moddecl = String::new();
        write!(&mut moddecl, "(function {name_upper} (").unwrap();
        for _ in &self.i_wires {
            write!(&mut moddecl, " Expr ").unwrap();
        }
        write!(&mut moddecl, ") Expr :cost 0)").unwrap();
        moddecl
    }
    pub fn into_rewrite(&self) -> String {
        let moddecl = self.into_mod();
        // map -> join the name / output with newline..?
        let name_lower = self.name.to_lowercase();
        let name_upper = self.name.to_uppercase();

        let mut lhs = String::new();
        let mut rhs = String::new();

        // FIXME: I did something stupid with the right hand side
        write!(&mut rhs, "(let {name_lower} ({name_upper} ").unwrap();
        for i in &self.i_wires {
            write!(&mut rhs, "{i} ").unwrap();
        }
        write!(&mut rhs, "))\n").unwrap();
        // println!("{rhs}");
        // &self.run_expr(&rhs, true);
        //
        for (i, (name, output_expr)) in self.out_map.iter().enumerate() {
            let i1 = i + 1;
            writeln!(&mut lhs, "(= {output_expr} {name})").unwrap();
            writeln!(
                &mut rhs,
                "(union {name} (Op1 (Extract {i1} {i}) {name_lower}))"
            )
            .unwrap();
        }
        let template = format!("{moddecl}\n(rule \n(\n{lhs}) \n({rhs}) :ruleset rewrites)");
        // TODO need to get all of the variables in the expression
        // Each of those vars need to go in the extract

        template.into()
    }
    pub fn src(&self) -> &str {
        &self.src
    }
    pub fn to_svg(&self) {
        let path = Path::new(&self.path).with_extension("svg");
        let serialized = &self.e.serialize_for_graphviz(true);
        let svg_path = Path::new(&path).with_extension("svg");
        let path_str = svg_path.to_str().unwrap();
        println!("Print svg to: {path_str}");
        serialized.to_svg_file(svg_path).unwrap();
    }
    pub fn run_expr(&mut self, st: &str, log: bool) {
        match &self.e.parse_and_run_program(&st) {
            Ok(msgs) => {
                println!("Running egraph {} succeed", &self.name);
                if log {
                    for msg in msgs {
                        println!("{msg}");
                    }
                }
            }
            Err(err) => {
                println!("Running egraph {} failed with error: {err}", &self.name);
                exit(1);
            }
        };
    }
    // FIXME: This doesn't really work. I want to figure out a way to get the size of all the nodes
    // in teh EGraph or the size in bytse of the Heap structure of the EGraph
    fn print_egraph_size(&mut self) {
        println!("Getting size");
        let r = self.e.print_size(None);
        println!("{:?}", r);
    }

    fn extract_rule(&self) -> String {
        let mut output = String::new();
        for (out_wire, _) in self.out_map.iter() {
            let _ = write(&mut output, format_args!("(extract {})", out_wire));
        }
        output
    }
    fn extracted_egraph(&mut self) -> Option<String> {
        let mut out = String::new();
        for (out_wire, _) in self.out_map.iter() {
            println!("{out_wire}");
            let rule = format!("(extract {})", out_wire);
            match &self.e.parse_and_run_program(&rule) {
                Ok(msgs) => {
                    for msg in msgs {
                        let _ = write!(&mut out, "(let {} {})\n", out_wire, msg);
                    }
                }
                Err(_err) => {
                    return None;
                }
            };
        }
        Some(out)
    }
    /// Extract the value of an output wire (or any expression) from an EGraph
    fn extract_value(egraph: &egglog::EGraph, value: &Value, sort: &ArcSort) -> Expr {
        let mut termdag = TermDag::default();
        let (_size, extracted) = egraph.extract(*value, &mut termdag, &sort);
        termdag.term_to_expr(&extracted)
    }

    /// Get the input wire names from an output expression (a wire)
    fn get_input_wires(e: &Expr) -> HashMap<Expr, Expr> {
        let v: Vec<(Expr, Expr)> = e.fold(&mut |s, out| {
            match s {
                call @ Call(a, childs) => {
                    // when the call is a "Var"
                    if *a == "Var".into() {
                        for child in childs {
                            match child {
                                // match the child with a literal string
                                Lit(egglog::ast::Literal::String(sym)) => {
                                    // regex for inputs
                                    if Self::match_symbol(sym, "i_").unwrap() {
                                        // this won't have a child where flatten will find more vars
                                        return vec![(call.clone(), Expr::Var(sym.clone()).into())];
                                    }
                                }
                                _ => {}
                            }
                        }
                    }
                }
                _ => (),
            }

            out.into_iter().flatten().collect()
        });
        v.into_iter().collect()
    }

    /// replace the values using a replacement map
    fn replace_in_expr(expr: &Expr, replacement_map: &HashMap<Expr, Expr>) -> Expr {
        expr.map(&mut |expr| {
            if replacement_map.contains_key(expr) {
                replacement_map[expr].clone()
            } else {
                expr.clone()
            }
        })
    }

    fn match_symbol(sym: &Symbol, re: &str) -> Result<bool> {
        let re_i = regex::Regex::new(re)?;
        Ok(re_i.is_match(&sym.to_string()))
    }
}

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
    env_logger::Builder::new()
        .filter_level(log::LevelFilter::Warn)
        .format_timestamp(None)
        .format_target(false)
        .parse_default_env()
        .init();
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

        // let rule = format!("(run-schedule (repeat 50 {deoptimize_rule} ))\n (run-schedule (repeat 50 {rewrite_rule} ))");

        // for each decode wire
        let r = s.into_rewrite();
        // let e = s1.extract_rule();
        let mut file = fs::File::create("rewrite.egg").unwrap();
        let _ = file.write(&r.clone().into_bytes());

        // s1.run_expr(&r, false);
        // s1.run_expr(&rule, true);
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
