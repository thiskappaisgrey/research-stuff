// TODO need to figure out 
use log::{info, trace, warn};
use env_logger::Env;
use egglog::{
    ast::{parse::ExprParser, Expr, Symbol},
    ArcSort,
    ExtractReport::*,
    ast::Expr::*,
    TermDag, Value, EGraph,
};
use clap::Parser;
use std::{path::Path, collections::HashMap, process::exit, fmt::Write};
use anyhow::Result;

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
// TODO build the righthand side of a rewrite rule!
// Need to traverse the AST and grab all of the output wires..?
// Instead - get a vec of expressions + their names then
// generate a rewrite..?
/// inputs should be the values of get_input_wires
/// outputs should be the output wire name and their associated expression 
fn build_rewrite(name: &str, inputs: &Vec<Expr>, outputs: &Vec<(String, Expr)>) -> String  {
    let ins: Vec<_> = inputs.iter().map(|p| {
        match *p {
            Var(sym) => {
                sym.as_str()
            }
            _ => {
                ""
            }
        }
    }).collect();

    // for each expression - get the names of the vars..?

    // map -> join the name / output with newline..?
    let name_lower = name.to_lowercase();
    let mut lhs = String::new();
    let mut rhs = String::new();
    write!(&mut rhs, "(let {name_lower} (Module \"{name}\" (Concat ").unwrap();
    for i in ins {
        write!(&mut rhs, "{i} ").unwrap();
    }
    write!(&mut rhs, ")))\n").unwrap();

    for (i, (name, output_expr)) in outputs.iter().enumerate() {
        let i1 = i + 1;
        writeln!(&mut lhs, "(= {output_expr} {name})").unwrap();
        writeln!(&mut rhs, "(union {name} (Extract {i1} {i} {name_lower}))").unwrap();
    }
    let template = format!("(rule \n(\n{lhs}) \n({rhs}) :ruleset rewrites)");

    // TODO need to get all of the variables in the expression
    // Each of those vars need to go in the extract

    
    template.into()
}


#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    lib_filename: String,
    mod_filename: Option<String>
}

fn main() {
    env_logger::Builder::new()
        .filter_level(log::LevelFilter::Warn)
        .format_timestamp(None)
        .format_target(false)
        .parse_default_env()
        .init();
    let args = Args::parse();

    // 1. load file into egglog
    // 2. try to generate rewrites based on it
    // 3. do the rewrite or something

    let mut std_mod_egraph = egglog::EGraph::default();
    let st = std::fs::read_to_string(Path::new(&args.lib_filename)).unwrap();
    // Need to traverse the AST for all of the output variables..?
    
    // println!("{st}");
    // TODO this is an unwrap
    match std_mod_egraph.parse_and_run_program(&st) {
        Ok(_msgs) => {
            // for msg in msgs {
            //     println!("{msg}");
            // }
            println!("Ran egglog succeed!");
        },
        Err(err) => {
            println!("{err}");
            exit(1);
        }
    };

    // Here, we have to clone because the hashmap references will be invalidated
    // when I mutate it by evaling an expression
    let output_wires: Vec<_> = std_mod_egraph.global_bindings.keys().filter(|p| {
        match_symbol(p, "o_").unwrap()
    }).cloned().collect();

    // maybe here, I build up a string that can go on the right hand side..?
    // need to figure out the left hand side first anyways..


    for wire in output_wires {
        let (sort, value) = std_mod_egraph
            .eval_expr(&egglog::ast::Expr::Var(wire.into()), None, true)
            .unwrap();

        let expr = extract_value(&std_mod_egraph, &value, &sort);
        println!("Original expression for {wire}: {expr}");
        let inputs = get_input_wires(&expr);
        let rep_expr = replace_in_expr(&expr, &inputs);
        println!("Replaced expression for {wire}: {rep_expr}");
    }

    


    // "mod_filename" is the file name of the module to find half_adders
    if let Some(name) = args.mod_filename {
        // 1. build up a new egraph
        let mut rewrite_mod_egraph = EGraph::default();
        let st = std::fs::read_to_string(Path::new(&args.lib_filename)).unwrap();
        println!("Running on Rewrite Module");
        match rewrite_mod_egraph.parse_and_run_program(&st) {
            Ok(_msgs) => {
                // for msg in msgs {
                //     println!("{msg}");
                // }
                println!("Ran egglog on rewrite_mod succeed!");
            },
            Err(err) => {
                println!("{err}");
            }
        };

        // 2. search for half_adders or any other value in that egraph
        // 3. rewrite them into half_adder modules
        // 4. (maybe?) go back into verilog somehow..?
        


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
            ("o_sum".into(), ExprParser::new().parse("(Op2 (And) i_sum i_carry)").unwrap()),
            ("o_carry".into(), ExprParser::new().parse("(Op2 (Xor) i_sum i_carry)").unwrap()),
        ];
        let ins: Vec<Expr> = vec![
            ExprParser::new().parse("i_sum").unwrap(),
            ExprParser::new().parse("i_carry").unwrap()
        ];
        let rule = build_rewrite(name, &ins,  &exprs);
        println!("Rule: {rule}");
        // assert false so it prints
        // assert!(false);
    }
}
