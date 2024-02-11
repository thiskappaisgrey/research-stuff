use serde::{Deserialize, Serialize};
use std::{fmt::Write, fs, path::Path, process::Command, rc::Rc, str::FromStr};
use tracing::{event, span, Level};

#[derive(Serialize, Deserialize, Debug)]
pub struct Src {
    src: Rc<str>,
    deps: Vec<Rc<str>>,
    mod_name: Rc<str>,
}
#[derive(Serialize, Deserialize, Debug)]
pub struct CellLib {
    src: Rc<str>,
    def: Rc<str>,
}

// some CLI related stuff
#[derive(Serialize, Deserialize, Debug)]
pub struct RewriteConfig {
    sources: Vec<Src>,           // sources for the rewrites
    top: Rc<str>,                // the top module
    yosys_script_base: Rc<str>,  // the base yosys to run
    yosys_path: Option<Rc<str>>, // by default - use the yosys from PATH
    outdir: Rc<str>,
    cell_lib: CellLib,
}

// TODO: Run the yosys script
impl RewriteConfig {
    // TODO: Move this out of the rust code and into nickel
    // Actually - I might want to move this out of this program altogether!
    // It would be useful for quickly configuring different yosys passes and such!
    fn gen_yosys(&self, src: &Src) -> String {
        let mut out = String::new();
        for ss in src.deps.iter() {
            let _ = write!(&mut out, "read_verilog -sv {ss};\n");
        }
        let s: &str = &src.src.to_owned();
        let top = Path::new(s);
        let _ = write!(&mut out, "read_verilog -sv {};\n", &src.src);
        let _ = write!(
            &mut out,
            "prep -top {};\nhierarchy -check -top {};\n",
            &src.mod_name, &src.mod_name
        );
        // prep -top myand;
        // hierarchy -check -top myand;
        let _ = write!(&mut out, "{}\n", self.yosys_script_base);

        // TODO: Allow configuration on whether to techmap or not..?
        let _ = write!(
            &mut out,
            "dfflibmap -liberty {}; techmap; opt; \n abc -liberty {};\n",
            self.cell_lib.src, self.cell_lib.src
        );
        let _ = write!(&mut out, "read_verilog {};\nflatten;\n", self.cell_lib.def);
        let s1: &str = &self.outdir.to_owned();
        let outpath = Path::new(s1).join(top.file_name().unwrap());

        let _ = write!(
            &mut out,
            "write_lakeroad {};\n",
            outpath.with_extension("egg").to_str().unwrap()
        );

        return out;
    }
    fn run_yosys(&self, src: &Src) {
        let span = span!(Level::ERROR, "run_yosys");
        let _guard = span.enter();

        let yosys: &str = &self.yosys_path.clone().unwrap_or("yosys".into()).to_owned();
        let outdir: &str = &self.outdir.to_owned();
        let temp_script = Path::new(outdir).join("script.ys");
        let script = self.gen_yosys(src);
        let _ = fs::write(&temp_script, script);
        let r = Command::new(&yosys).args([&temp_script]).output();
        match r {
            Err(e) => {
                event!(Level::ERROR, "Error running yosys: {e}");
            }
            Ok(r) => {
                event!(
                    Level::INFO,
                    "Result of running yosys:\n {}",
                    String::from_utf8(r.stderr).unwrap()
                );
            }
        }
    }

    pub fn run(&self) {
        // for each source, run the yosys script
        for src in self.sources.iter() {
            event!(Level::INFO, "Running yosys for: {}", src.src);
            self.run_yosys(src);
        }
    }
}
