#import "@preview/fletcher:0.4.0" as fletcher: node, edge

#align(center, text(17pt)[
  *Hardware Decompilation Through Equality Saturation*
])
#align(center, text(11pt)[
  _Thanawat Techaumnuaiwit_
])
#linebreak()

Hardware decompilation is the process of recovering higher-level programming abstractions within a _netlist_.  Our previous work established the new problem of _hardware decompilation_ and introduces a pass for _hardware loop rerolling_. We propose a new pass for doing hardware decompilation which identifies standard libary components in a gate-level netlist by using Equality Saturation to efficiently search for the standard libary component in the netlist.
We achieve this by extracting a rewrite rule from EGraph representation of the standard library component. By applying the extracted rewrite rule and the standard rewrite rules for logical equivalences on the EGraph representation of the gate-level netlist, we can extract out the standard libary components we are looking for. Future work includes  generating or creating with other forms of rewrites to extract out other sorts of high level abstractions.
#linebreak()
#linebreak()
#linebreak()
#linebreak()



#figure(fletcher.diagram(
	node-outset: 2pt,
	axes: (ltr, btt),

	node((0,3), "Gate-Level Netlist", fill: rgb("#a3be8c")),
	node((0,2), "Gate-Level Netlist EGraph", fill: rgb("#ebcb8b")),
	node((.9,3), "STD Lib Component", fill: rgb("#a3be8c")),
	node((.9,2), "STD Lib EGraph", fill: rgb("#ebcb8b")),
	node((.9,1), "STD Lib Rewrite Rule", fill: rgb("#ebcb8b")),
	node((1.8,3), "Logical Equiv Rewrite Rules", fill: rgb("#a3be8c")),
	node((.9, -1), $times.circle$, shape: "circle", fill: rgb("#d08770")),
	node((.9, -3), "Gate-Level Netlist w/ stdlib annotations",  fill: rgb("#bf616a")),
	edge((.9, 3), (.9, 2), "->", label: "Yosys backend"),
	edge((.9, 2), (.9, 1), "->", label: "Rust/Egglog meta program"),
	edge((0, 3), (0, 2), "->", label: "Yosys backend"),
	edge((0, 2), (.9, -1), "->", bend: -50deg),
	edge((1.8, 3), (.9, -1), "->", bend: 55deg),
	edge((.9, 1), (.9, -1), "->"),
	edge((.9, -1), (.9, -3), "->", label: "Equality Saturation"),
), caption: [Diagram of the process])

