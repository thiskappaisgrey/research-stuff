mod cli;
use std::{env::set_current_dir, path::Path};

use crate::cli::RewriteConfig;
use clap::Parser;
use tracing::{error, info, warn};
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
    let lib = Path::new(&args.lib_filename);
    let st = std::fs::read_to_string(lib).unwrap();
    let c: serde_json::Result<RewriteConfig> = serde_json::from_str(&st);

    if let Some(dir_name) = lib.parent() {
        info!("Changing dir to: {}", dir_name.to_str().unwrap());
        if set_current_dir(dir_name).is_err() {
            warn!("Failed to change the diretory");
        }
    }

    match c {
        Err(e) => {
            println!("error deserializing: {e}");
        }
        Ok(s) => {
            s.run();
        }
    }
}
