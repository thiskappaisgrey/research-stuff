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
    fmt::Write,
    path::Path,
    process::exit,
};

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
                                if match_symbol(sym, "i_").unwrap() {
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

// FIXME: Rewrite this rule to match the new lakeroad lang -
// We can extract stuff from "apply"s
fn build_rewrite(name: &str, inputs: &Vec<String>, outputs: &Vec<(String, Expr)>) -> String {
    // map -> join the name / output with newline..?
    let name_lower = name.to_lowercase();
    let mut lhs = String::new();
    let mut rhs = String::new();

    // TODO I might use different syntax here..
    write!(
        &mut rhs,
        "(let {name_lower} (Module \"{name}\" (Op2 (Concat) "
    )
    .unwrap();
    for i in inputs {
        write!(&mut rhs, "{i} ").unwrap();
    }
    write!(&mut rhs, ")))\n").unwrap();

    for (i, (name, output_expr)) in outputs.iter().enumerate() {
        let i1 = i + 1;
        writeln!(&mut lhs, "(= {output_expr} {name})").unwrap();
        writeln!(
            &mut rhs,
            "(union {name} (Op1 (Extract {i1} {i}) {name_lower}))"
        )
        .unwrap();
    }
    let template = format!("(rule \n(\n{lhs}) \n({rhs}) :ruleset rewrites)");
    // TODO need to get all of the variables in the expression
    // Each of those vars need to go in the extract

    template.into()
}

fn to_svg(e: &EGraph, path: &str) {
    let serialized = e.serialize_for_graphviz(true);
    let svg_path = Path::new(&path).with_extension("svg");
    let path_str = svg_path.to_str().unwrap();
    println!("Print svg to: {path_str}");
    serialized.to_svg_file(svg_path).unwrap();
}

/// Runs the Egg file - exits the program if the fail failed
fn run_egg_file(e: &mut EGraph, name: &str, egg: &str) {
    println!("Running egraph {name}");
    match e.parse_and_run_program(egg) {
        Ok(_msgs) => {
            println!("Running egraph {name} succeed");
        }
        Err(err) => {
            println!("Running egraph {name} failed with error: {err}");
            exit(1);
        }
    };
}

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// The library definition you want to find
    lib_filename: String,
    /// The module where you are looking
    mod_filename: Option<String>,
}

fn main() {
    env_logger::Builder::new()
        .filter_level(log::LevelFilter::Warn)
        .format_timestamp(None)
        .format_target(false)
        .parse_default_env()
        .init();
    let args = Args::parse();

    let lang_lib = include_str!("../egglog_src/lang.egg");
    let rewrite_lib = include_str!("../egglog_src/rewrite.egg");
    // let optimize_lib = include_str!("../egglog_src/optimize.egg");

    // 1. load file into egglog
    // 2. try to generate rewrites based on it
    // 3. do the rewrite or something

    let mut std_mod_egraph = egglog::EGraph::default();
    // this is the egg_src rewrite lib
    std_mod_egraph.parse_and_run_program(lang_lib).unwrap();
    // std_mod_egraph.parse_and_run_program(optimize_lib).unwrap();
    let lib_file = Path::new(&args.lib_filename);
    let st = std::fs::read_to_string(lib_file).unwrap();
    run_egg_file(&mut std_mod_egraph, &args.lib_filename, &st);
    to_svg(&std_mod_egraph, &args.lib_filename);
    //  ---- REWRITE STUFF ----
    // Here, we have to clone because the hashmap references will be invalidated
    // when I mutate it by evaling an expression
    let output_wires: Vec<_> = std_mod_egraph
        .global_bindings
        .keys()
        .filter(|p| match_symbol(p, "o_").unwrap())
        .cloned()
        .collect();

    // maybe here, I build up a string that can go on the right hand side..?
    // need to figure out the left hand side first anyways..
    let mut i_wires: HashSet<String> = HashSet::new();
    let out_map: Vec<(String, Expr)> = output_wires
        .into_iter()
        .map(|wire| {
            println!("Extracting {wire}");
            let (sort, value) = std_mod_egraph
                .eval_expr(&egglog::ast::Expr::Var(wire.into()), None, true)
                .unwrap();

            let expr = extract_value(&std_mod_egraph, &value, &sort);
            let inputs = get_input_wires(&expr);
            let rep_expr = replace_in_expr(&expr, &inputs);
            inputs.values().for_each(|input| {
                i_wires.insert(input.to_string());
            });
            (wire.to_string(), rep_expr.clone())
        })
        .collect();
    // TODO: Need to fix this up.
    let rewrite = build_rewrite(
        lib_file.file_stem().unwrap().to_str().unwrap(),
        &i_wires.into_iter().collect(),
        &out_map,
    );
    println!("{rewrite}");
    // --- end of REWRITE stuff ---

    // "mod_filename" is the file name of the module to find half_adders
    if let Some(name) = args.mod_filename {
        println!("Match on: {name}");
        // 1. build up a new egraph
        let mut rewrite_mod_egraph = EGraph::default();

        rewrite_mod_egraph.parse_and_run_program(lang_lib).unwrap();
        rewrite_mod_egraph
            .parse_and_run_program(rewrite_lib)
            .unwrap();

        let st = std::fs::read_to_string(Path::new(&name)).unwrap();
        rewrite_mod_egraph.parse_and_run_program(&rewrite).unwrap();

        // rewrite_mod_egraph.parse_and_run_program(&rewrite).unwrap();
        match rewrite_mod_egraph.parse_and_run_program(&st) {
            Ok(_msgs) => {
                println!("Ran egglog on rewrite_mod succeed!");
            }
            Err(err) => {
                println!("Error {err}");
                exit(1);
            }
        };
        // println!("Rewrite is: {rewrite}");
        // TODO: Don't want to run rewrite
        // TODO: Make the typing into flags +
        // I want to be able to run _detructive_ optimizations and see
        // if egglog can "undo" those optimizations - but I need to figure out
        // what they are..
        let rewrite = true;
        let deoptimize = true;
        let rewrite_rule = if rewrite { "(saturate rewrites)" } else { "" };
        let deoptimize_rule = if deoptimize {
            "(saturate deoptimize)"
        } else {
            ""
        };

        let rule = format!("(run-schedule (repeat 10 {deoptimize_rule} {rewrite_rule}  ))");
        match rewrite_mod_egraph.parse_and_run_program(&rule) {
            Ok(msgs) => {
                println!("Run rewrites succeeded");
                for msg in msgs {
                    println!("{msg}");
                }
            }
            Err(err) => {
                println!("Run schedule failed: {err}");
                exit(1);
            }
        }
        println!("Ran schedule");

        let serialized = rewrite_mod_egraph.serialize_for_graphviz(true);
        let svg_path = Path::new(&name).with_extension("svg");
        serialized.to_svg_file(svg_path).unwrap();
    }
    // Actually - instead of using an egglog style rewrite rule..
    // Can I just directly, in the rust code, do the search for half_adders..?
}

#[cfg(test)]
mod test {
    use egglog::ast::{parse::ExprParser, Expr};

    use crate::build_rewrite;

    #[test]
    fn my_test() {
        // TODO the lhs need to be more sophisticated..
        let name = "HalfAdd";
        let exprs: Vec<(String, Expr)> = vec![
            (
                "o_sum".into(),
                ExprParser::new()
                    .parse("(Op2 (And) i_sum i_carry)")
                    .unwrap(),
            ),
            (
                "o_carry".into(),
                ExprParser::new()
                    .parse("(Op2 (Xor) i_sum i_carry)")
                    .unwrap(),
            ),
        ];
        let ins: Vec<String> = vec!["i_sum".into(), "i_carray".into()];
        build_rewrite(name, &ins, &exprs);

        // assert false so it prints
        // assert!(false);
    }
}
