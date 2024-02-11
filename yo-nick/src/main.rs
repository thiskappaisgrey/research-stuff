mod cli;
use crate::cli::RewriteConfig;
use clap::Parser;
use tracing_subscriber;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args1 {
    /// The library definition you want to find
    lib_filename: String,
}

pub fn main() {
    tracing_subscriber::fmt::init();

    let args = Args1::parse();
    let st = std::fs::read_to_string(args.lib_filename).unwrap();
    let c: serde_json::Result<RewriteConfig> = serde_json::from_str(&st);
    match c {
        Err(e) => {
            println!("error deserializing: {e}");
        }
        Ok(s) => {
            s.run();
        }
    }
}
