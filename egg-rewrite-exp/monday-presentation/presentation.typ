#import "@preview/polylux:0.3.1": *
#set page(paper: "presentation-16-9", fill: rgb("#3b4252"))
#set text(size: 25pt, fill: rgb("#d8dee9"))
#set raw(theme: "Nord.tmTheme")

#polylux-slide[
  #align(horizon + center)[
    = Small Example on rewrite rules

    Thanawat Techaumnuaiwit

    July 23, 2023
  ]
]
#polylux-slide[
  == Install
   - My github repo is on: https://github.com/thiskappaisgrey/research-stuff
   - If you want to build it, you can use _nix_ to install the dependencies.
   - You do need the forked repo of lakeroad-yosys (I failed to do git submodules correctly, so for now, you'll have to clone it yourself) with the egglog branch for this to work..
   - The nix derivation already includes teh yosys dependencies to build.
]

#polylux-slide[
  == Half Adder example
  - The simplest example is finding half adders in a full-adder implementation
  - We can use egglog to do _subgraph isomorphism_ - find the half-adder in the full adder!
  - Basically - we build the component as a subgraph and use Egglog to find that subgraph in a bigger graph. This example only has the 1 "naive" rewrite rule.
  - Run `just build-full-adder` to build the example.
]
#polylux-slide[
  === Half adder
  #figure(image("./half_adder.svg", height: 80%), caption: [
  The half adder is used to build up the rewrite rule
  ])
]
#polylux-slide[
  === Full Adder
  #figure(image("./full_adder.svg", height: 50%), caption: [
  The rewrite rule built by the half adder is used to search for it in the full adder
  ])

]


#polylux-slide[
  == XOR example
  - Finding an XOR gate in a graph with the XORs compiled away(i.e. translated to and/not gates) is much harder.
    - Nodes can be "merged" together during the compilation process where the XORs can be harder to find
  - We can't just use "subgraph isomorphism" to find the XOR implementation anymore! We "continuosly deform" the graph using more rewrite rules in order to find the XOR implementation!
  - I'll call this problem - "subgraph homotopy"#footnote[I'm not a mathematician but I'm using big words to sound smart]
]
#polylux-slide[
  === XOR compiled 
  #figure(image("./xor.svg", height: 50%), caption: [
  This is the XOR compiled
  ])
]
#polylux-slide[
  === Rewrites that were added
  ```lisp
;; absorbtion.
(rewrite 
 (Op2 (Or) x (Op2 (And) x y))
 x
 :ruleset deoptimize)

(rewrite 
 (Op2 (And) x (Op2 (Or) x y))
 x
 :ruleset deoptimize)
;; commutativity
(birewrite 
 (Op2 (And) x y)
 (Op2 (And) y x)
 :ruleset deoptimize)
(birewrite 
 (Op2 (Or) x y)
 (Op2 (Or) y x)
 :ruleset deoptimize)

;; idempotence
(rewrite 
        (Op2 (And) x x)
        x
        :ruleset deoptimize
  )
(rewrite 
        (Op2 (Or) x x)
        x
        :ruleset deoptimize
  )
;; De Morgansk

(birewrite 
        (Op1 (Not) (Op2 (And) x y))
        (Op2 (Or) (Op1 (Not) x) (Op1 (Not) y))
        :ruleset deoptimize
  )

(birewrite 
        (Op1 (Not) (Op2 (Or) x y))
        (Op2 (And) (Op1 (Not) x) (Op1 (Not) y))
        :ruleset deoptimize
  )
  ```
]
#polylux-slide[
  === Looking for XORs in a "bigger" circuit
  #figure(image("./test1.svg", height: 50%), caption: [
  Here, we find the compiled XOR in a slightly bigger circuit by adding the above rewrites
  ])
]

#polylux-slide[
  === The "circuit"
  ```verilog
module test(
        input a,
        input b,
        output d,
        output c
);
        assign d = a & b; 
        assign c = a ^ b;
endmodule
  ```
  ]
  #polylux-slide[
    = Conclusion
    - We can use a number of passes to find our component in a bigger circuit.. i.e. continuosly deform the graph into the form that we "want" to find.
    - Some difficulties after we find the module is _extracting_. ENodes can be a part of multiple modules - we have to ensure that they are "comsumed" by the modules at most once.

    ]
