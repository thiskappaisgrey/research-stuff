use std::{
    env, fs,
    io::{self, Read},
};
use std::path::PathBuf;
// use clap::{Parser, Subcommand};
// TODO for holes
// use clap_stdin::FileOrStdin;

use tree_sitter::{Language, Parser, Query, QueryCursor};
use tree_sitter_graph::{ast::File, ExecutionConfig, NoCancellation};
use tree_sitter_graph::{functions::Functions, Variables};
use tree_sitter_verilog::language;
mod graph;


// I basically want options for:
// 1. getting annotations from modules -
// 2. given some "input" file with holes and some stuff from stdin - do the tree-sitter hole-filling stuff.
// #[derive(Parser)]
// #[command(author, version, about, long_about = None)]
// struct Cli {
//     name: Option<String>,
//     #[arg(short, long, value_name = "FILE")]
//     config: Option<PathBuf>,
//     /// Turn debugging information on
//     #[arg(short, long, action = clap::ArgAction::Count)]
//     debug: u8,

//     // #[command(subcommand)]
//     // command: Option<Commands>,
// }
// TODO maybe I don't even need to implement my own graph at all and just get it from the Tree-Sitter graph..?
// I will just write my own graph data structure for practice - 


// TODO use clap to do a cli interface
// this tool can do 2 stuff, basically get out the annotations from source file
// and "synthesize" by assigning the correct values to wires.
pub fn tsg_main() {
    // grab the python file from the input
    let input_path = env::args().nth(1).unwrap();
    // TODO should prob populate this at compile time(this is the comment-anno.tg file).
    let tsg_path = env::args().nth(2).unwrap();
    
    let source_code = fs::read_to_string(input_path).unwrap();
    let mut parser = Parser::new();
    parser.set_language(language()).unwrap();

    // TODO read the file from stdin and then try to do some stuff
    let tree = parser.parse(&source_code, None).unwrap();
    let root_node = tree.root_node().to_sexp();
    println!("{root_node:?}");
    // let query = Query::new(language(), "(assignment)@assignment").unwrap();
    let tsg_f = std::fs::read(tsg_path).unwrap();
    let tsg = String::from_utf8(tsg_f).unwrap();
    let file = File::from_str(language(), &tsg).unwrap();
    let mut globals_ = Variables::new();

    let functions = Functions::stdlib();
    let mut config = ExecutionConfig::new(&functions, &globals_).lazy(true);

    // TODO you can prob build a netlist from verilog RTL using this
    
    let graph = file
        .execute(&tree, &source_code, &mut config, &NoCancellation)
        .unwrap();
    println!("Graph is: {}", graph.pretty_print());

    // TODO Figure out how to visualize stuff (prob just use dot - since it's easiest) 
    // TODO need to figure out how to map from this to that..
    // let cli = Cli::parse();
    // // You can check the value provided by positional arguments, or option arguments
    // if let Some(name) = cli.name.as_deref() {
    //     println!("Value for name: {name}");
    // }

    // if let Some(config_path) = cli.config.as_deref() {
    //     println!("Value for config: {}", config_path.display());
    // }

    // // You can see how many times a particular flag or argument occurred
    // // Note, only flags can have multiple occurrences
    // match cli.debug {
    //     0 => println!("Debug mode is off"),
    //     1 => println!("Debug mode is kind of on"),
    //     2 => println!("Debug mode is on"),
    //     _ => println!("Don't be crazy"),
    // }


}

pub fn main() {
    graph::main();
}
