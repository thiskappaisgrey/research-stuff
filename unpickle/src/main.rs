use std::collections::HashMap;
use std::env;
use std::path::PathBuf;
use sv_parser::{parse_sv, unwrap_locate, unwrap_node, Locate, RefNode};

fn main() {
    let args: Vec<String> = env::args().collect();

    // The path of SystemVerilog source file
    let path = PathBuf::from(&args[1]);
    // The list of defined macros
    let defines = HashMap::new();
    // The list of include paths
    let includes: Vec<PathBuf> = Vec::new();

    // Parse
    let result = parse_sv(&path, &defines, &includes, false, false);

    if let Ok((syntax_tree, _)) = result {
        // &SyntaxTree is iterable
        for node in &syntax_tree {
            // The type of each node is RefNode
            match node {
                // Each "RefNode" has indirection - where to continue traversing,
                // you have to get out the value first..? (x -> &ModuleDeclaration - and x is
                // iterable)
                RefNode::ModuleDeclaration(x) => {
                    // TODO: For each node - write the module declaration in the file
                    // in the same directory..?
                    //
                    let str = syntax_tree.get_str(x).unwrap();
                    println!("Def: {}", str);
                }
                _ => (),
            }
        }
        // dbg!(syntax_tree);
    } else {
        println!("Parse failed");
    }
}

fn get_identifier(node: RefNode) -> Option<Locate> {
    // unwrap_node! can take multiple types
    match unwrap_node!(node, SimpleIdentifier, EscapedIdentifier) {
        Some(RefNode::SimpleIdentifier(x)) => {
            return Some(x.nodes.0);
        }
        Some(RefNode::EscapedIdentifier(x)) => {
            return Some(x.nodes.0);
        }
        _ => None,
    }
}
