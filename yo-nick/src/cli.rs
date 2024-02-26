use serde::{Deserialize, Serialize};
use std::{
    env::set_current_dir, fmt::Write, fs, path::Path, process::Command, rc::Rc, str::FromStr,
};
use tracing::{error, info, span, warn, Level};

#[derive(Serialize, Deserialize, Debug)]
pub struct Src {
    source: Vec<String>,
    yosys_script: String,
}

// TODO: The yosys script generation will be outside of rust
#[derive(Serialize, Deserialize, Debug)]
pub struct RewriteConfig {
    sources: Vec<Src>,          // sources for the rewrites
    yosys_path: Option<String>, // by default - use the yosys from PATH
    outdir: String,
}

// TODO: Run the yosys script
impl RewriteConfig {
    // TODO: Move this out of the rust code and into nickel
    // Actually - I might want to move this out of this program altogether!
    // It would be useful for quickly configuring different yosys passes and such!

    // In theory I can run them in parallel as well lmao
    fn run_yosys(&self, src: &Src) {
        let span = span!(Level::INFO, "run_yosys");
        let _guard = span.enter();

        let yosys: &str = &self.yosys_path.clone().unwrap_or("yosys".into()).to_owned();
        let outdir: &str = &self.outdir.to_owned();
        let temp_script = Path::new(outdir).join("script.ys");
        let script = &src.yosys_script;
        let _ = fs::write(&temp_script, script);
        let r = Command::new(&yosys).args([&temp_script]).output();
        match r {
            Err(e) => {
                error!("Error running yosys: {e}");
            }
            Ok(r) => {
                info!(
                    "Result of running yosys:\n {}",
                    String::from_utf8(r.stderr).unwrap()
                );
            }
        }
    }

    pub fn run(&self) {
        // set_current_dir()
        for src1 in self.sources.iter() {
            for src in src1.source.iter() {
                let p = Path::new(&src);
                if !p.is_file() {
                    error!("The soucre {} does not exist! Exiting", src);
                }
            }
        }

        // for each source, run the yosys script
        for src in self.sources.iter() {
            info!("Running yosys for: {}", src.source[0]);
            self.run_yosys(src);
        }
    }
}
