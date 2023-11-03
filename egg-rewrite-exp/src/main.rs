// TODO need to figure out 
use log::{info, trace, warn};
use env_logger::Env;
use egglog::{
    ast::{parse::ExprParser, Expr, Symbol},
    ArcSort,
    ExtractReport::*,
    ast::Expr::*,
    TermDag, Value,
};
use clap::Parser;
use std::{path::Path, collections::HashMap};


/// Extract the value of an output wire (or any expression) from an EGraph
fn extract_value(egraph: &egglog::EGraph, value: &Value, sort: &ArcSort) -> Expr {
    let mut termdag = TermDag::default();
    // TODO maybe I want to print out the term dag to see what gets done to it..?
    let (_size, extracted) = egraph.extract(*value, &mut termdag, &sort);
    termdag.term_to_expr(&extracted)
}

/// Get the input wire names from an output expression (a wire)
// TODO this can just directly generate the replacement map
fn get_input_wires(e: &Expr) -> HashMap<Expr, Expr> {
    let mut v: Vec<(Expr, Expr)> = e.fold(&mut |s, out| {
        // 1 + (out.iter().sum::<u32>())
        match s {
            // TODO the "shape" of this is a "Call var"
            call @ Call(a, childs) => {
                // when the call is a "Var"
                if *a == "Var".into() {
                    for child in childs {
                        match child {
                            // match the child with a literal string
                            Lit(egglog::ast::Literal::String(sym)) => {
                                // regex for inputs
                                let re_i = regex::Regex::new(r"^i_").unwrap();
                                let sym_str: String = sym.to_string();
                                if re_i.is_match(&sym_str) {
                                    // this won't have a child where flatten will find more vars
                                    return vec![(call.clone(), Expr::Var(sym_str.into()).into())];
                                }
                            }
                            _ => {}
                        }
                    }
                    // return 1 + out.into_iter().sum::<u32>();
                }
            }
            _  => {
                ()
            }
        }

        out.into_iter().flatten().collect()
    });
    v.into_iter().collect()

}


/// replace the values using a replacement map
fn replace_in_expr(expr: &Expr, replacement_map: &HashMap<Expr, Expr>) -> Expr {
    // Is this only 1 layer of mapping
    // or a recursive layer..?
    expr.map(&mut |expr| {
        if replacement_map.contains_key(expr) {
            replacement_map[expr].clone()
        } else {
            expr.clone()
        }
    })
}


// TODO build the righthand side of a rewrite rule!



#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Name of the person to greet
    filename: String,
}

fn main() {
    // println!("Hello, world!");

    // set the default logging level to trace
    env_logger::Builder::new()
        .filter_level(log::LevelFilter::Warn)
        .format_timestamp(None)
        .format_target(false)
        .parse_default_env()
        .init();
    let args = Args::parse();

    println!("Hello {}!", args.filename);
    // 1. load file into egglog
    // 2. try to generate rewrites based on it
    // 3. do the rewrite or something

    let mut egraph = egglog::EGraph::default();
    let st = std::fs::read_to_string(Path::new(&args.filename)).unwrap();
    // println!("{st}");
    // TODO this is an unwrap
    match egraph.parse_and_run_program(&st) {
        Ok(_msgs) => {
            // for msg in msgs {
            //     println!("{msg}");
            // }
            println!("Ran egglog succeed!");
        },
        Err(err) => {
            println!("{err}");
        }
    };

    // grab the sort / value - not sure what that is..

    // This is the let-binding we are trying to extract out
    // i.e. the "random" expression
    let (sort, value) = egraph
        // sum for half_adder
        .eval_expr(&egglog::ast::Expr::Var("o_sum".into()), None, true)
        .unwrap();
    let expr = extract_value(&egraph, &value, &sort);
    println!("Original Expression: {expr}");
    let inputs = get_input_wires(&expr);
    for (key, value) in &inputs {
        println!("{}, {}", key, value);
    }
    let rep_expr = replace_in_expr(&expr, &inputs);
    println!("Expression after replacement: {rep_expr}");
}
