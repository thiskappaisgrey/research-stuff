use core::fmt;
use std::{rc::Rc, fmt::Display};
use std::collections::VecDeque;
use dot_writer::{Color, DotWriter};

// TODO look at: https://github.com/Quantomatic/quizx/blob/master/quizx/src/vec_graph.rs for inspiration

// Nodes - primitive nodes
// My graph data structure..
// Let's say I want to represent:
// (a \land b) \land c in this graph repesentation .. how would I do it?
// And how might I translate from a "Gate" back into an equation?



// Try to identify Blocks and convert them into Gates using graph rewrites
#[derive(Debug)]
pub enum GateVariant {
    // Gates and not gates are binary for now..
    And,
    Xor,
    Not,
    // Dup, // TODO not sure if I need to make duplication explicit..?
    // OneBitAdder // trying to rewrite into this gate
}

// Let's ignore making types for the gates for now.. (everything will be untyped)

// Gates are either "primitive" gates or "block" gate
#[derive(Debug)]
pub struct Gate {
    // Name of the gate - Maybe this can be the "gatetype"
    name: GateVariant, // https://www.youtube.com/watch?v=A4cKi7PTJSs - lmao
    // You might have gates that point to themselves.. so maybe do use Rc..?
    inputs: u64,
    outputs: u64
}

impl Display for Gate {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         write!(f,"{:?}|{},{}|", self.name, self.inputs, self.outputs)
    }
    
}

use GateVariant::*;

impl Gate {
    // TODO be able to add inputs and outputs
    pub fn new(name: GateVariant, inputs: u64, outputs: u64) -> Self {
        Gate {
            name,
            inputs,
            outputs,
        }
    }
    // "and" gate
    pub fn and() -> Self {
        Self::new(And, 2, 1)
    }
    pub fn xor() -> Self {
        Self::new(Xor, 2, 1)
    }
    pub fn not() -> Self {
        Self::new(Not, 1, 1)
    }
    // pub fn dup() -> Self {
    //     Self::new(Dup, 1, 2)
    // }
    // "or" gate
}


// A "node" is just the node in the DAG
#[derive(Debug)]
pub enum Node {
    G(Gate),
    B(Block),
    In,
    Out
}
impl Display for Node {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            G(d) => write!(f,"{}", d),
            B(d) => write!(f,"Block"),
            In => write!(f,"In"),
            Out => write!(f,"Out")
        }
    }
}
// Theoretically - assigning to a new wire is the same thing as duplicating it 
// But maybe multiple connections from a node is just "duplication"

// Make it so that the only named wires are inputs and outputs

// A block is just a graph
#[derive(Debug)]
pub struct Block {
    // TODO the inputs and outputs should be immutable
    // They are "nodes"
    // TODO to be able to map from syntax - I need to keep track of wires to nodes
    inputs: u64,
    outputs: u64,
    // The internal representation of the gate
    nodes: Vec<Node>, // The id can just be the index to the vector..? 
    edges: Vec<(usize, usize)>
}



// DAG representation of a circuit
use Node::*;
impl Block {
    pub fn new(inputs: u64, outputs: u64) -> Self {
        // The beginning of the 
        let ins: Vec<Node> = (0..inputs).map(|_| { In }).chain( (0..outputs).map(|_| { Out })).collect();
        
        Block {
            inputs,
            outputs,
            nodes: ins,
            edges: vec![]
        }
    }
    pub fn add_node(&mut self, n: Node) {
        self.nodes.push(n);
    }
    pub fn add_nodes(&mut self, n: Vec<Node>) {
        self.nodes.extend(n)
    }
    // May fail adding edge if node doesn't exist
    pub fn add_edge(&mut self, e: (usize, usize)) -> Option<()> {
        let (n1, n2) = e;
        if n1 >= self.nodes.len() || n2 >= self.nodes.len() {
            return None;
        }
        self.edges.push(e);
        Some(())
    }
    // TODO specialized BFS just to printout the circuit..?
    // Print the dot representation of the circuit
    pub fn print_circ(&self) {
        // TODO I guess I can print the circuit vertically..?
        let mut output_bytes = Vec::new();
        {
            let mut writer = DotWriter::from(&mut output_bytes);
            writer.set_pretty_print(false);
            let mut graph = writer.digraph();
            // TODO loop through edges and add them to the graph
            // TODO blocks need to make up subgraphs (visually)
            for (e1, e2) in &self.edges {
                let n1 = &self.nodes[*e1];
                let n2 = &self.nodes[*e2];
                
                graph.edge(format!("\"{n1}_{e1}\""), format!("\"{n2}_{e2}\""));
                // let s: u8 = n1;
            }
        }
        println!("{}", String::from_utf8(output_bytes).unwrap())
    }

    // TODO given a node number - get's it's children node numbers

    // TODO given a node number - get it's parent node numbers

    // TODO traverse the DAG "catamorphically" going from
    // Block -> ReducedBlock (by constructing a new block through travesal rather than messing with the original block..?)

    // TODO have a way to represent graph rewrites..
    // by doing graph rewrites..
    
    // TODO write a DAG..?
    // TODO Do a BFS to traverse the graph to print out the connections

    // TODO visitor pattern / catamorphically do graph rewrites..?

    // TODO add a sanity check - outputs should only have 1 wire going into it
    // TODO Gates can exactly have same number of inputs pointing to it

    // The arity of inputs / outputs are 1, 1 respectively (but you could "vectorize" but we don't know how to deal with that yet)
}
// This is just to test things
pub fn main() {
    let mut half_adder = Block::new(2, 2);
    // TODO nodes have to be added before edges
    half_adder.add_node(G(Gate::and()));
    half_adder.add_node(G(Gate::xor()));
        
    // TODO:
    //  0   1   2    3     4                                            5
    // [In, In, Out, Out, G(Gate { name: And, inputs: 2, outputs: 1 }), G(Gate { name: Xor, inputs: 2, outputs: 1 })]
        
    // TODO here, inputs are implicitly ided 
    // 0 and 1 respectively
        
    // different connections represent duplication
    // Wire from input to gates
    half_adder.add_edge((0, 4));
    half_adder.add_edge((0, 5));
    half_adder.add_edge((1, 4));
    half_adder.add_edge((1, 5));
        
    // Wire from gate to outputs 
    half_adder.add_edge((4, 2));
    half_adder.add_edge((5, 3));

    // TODO How would I represent something like - 
    // 
    // trying to represent the gate:
    // 1-bit adder: (3, 2) - need to represent in some sort of a graph

    // println!("{:?}", half_adder);
    half_adder.print_circ();

}


#[cfg(test)]
mod tests {
    use crate::graph::{Block, Node::*, Gate};
    #[test]
    fn it_works() {
        // represent halfadd:
        // Here - we want to ignore the order of inputs
        // b/c they don't matter due to commutativity
        // halfAdd x y = (and2 x y, xor2 x y)

        // TODO figure out a way to make bigger gates.. + Delays
        assert!(true);
    }
}
// pub struct Graph {
//     nodes: ,
//     edges: 
// }
