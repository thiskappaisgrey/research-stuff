// Get Polylux from the official package repository
#import "@preview/polylux:0.3.1": *
#import "@preview/prooftrees:0.1.0"

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9", fill: rgb("#3b4252"))
#set text(size: 25pt, fill: rgb("#d8dee9"))
#set raw(theme: "Nord.tmTheme")

#let vdash = [⊢]
// #set rect(stroke: .5pt,  fill: rgb("#d8dee9"))
// #set prooftrees.tree_config(stroke:  1pt + rgb("#d8dee9"))

// Use #polylux-slide to create a slide and style it using your favourite Typst functions
#polylux-slide[
  #align(horizon + center)[
    = Type Checking

    Thanawat Techaumnuaiwit

    July 23, 2023
  ]
]
#polylux-slide[
  == A note on Debugging
  - If you haven't seen Piazza already, make sure you *learn gdb*. 
  - We can't debug everyone's segfaults - you need to learn how to debug them on your own!
  - Here #link("https://www.youtube.com/watch?v=PorfLSr3DDI")[resource I used] (more on the Piazza post)
]
#polylux-slide[
  == Understanding Type Checking 
  - Type checking is a *bottom up algorithm* the form of: _given the context, if we assert that something is true in that context(premise), we add a new fact to the context(conclusion)._
  - Example - typing the python ternary operator (```python x if y else z``` ):
  #prooftrees.tree(
    prooftrees.axi(pad(bottom: 5pt, [$gamma vdash  x : "boolean" "    " gamma vdash y : T "    "  gamma vdash z : T$])),
    prooftrees.uni(line_config: (stroke: 0.5pt + rgb("#d8dee9")))[$y "if" x "else" z : T$],
  )
  - In order to check the parent nodes - *you need to check the child nodes first*.
]

#polylux-slide[
  == The Context: Symtab
  - Symtab is a "Map" data structure (i.e. Python Dictionaries, HashMaps, etc) that maps a ```cpp char* name``` to a ```cpp Symbol*```. This is the _context_ that will iteratively get updated _as you visit each AST node_.
  - It's two important operations are:
    - ```cpp  Symbol* lookup(const char* name);``` , for looking up a symbol in the table.
    - ```cpp bool insert(char* name, Symbol* s);``` , for inserting a symbol in the table.
    - The other ones are related to *scope* which I will talk about later.
  - You can find more operations for this type in: `symtab.hpp`.
]
#polylux-slide[
  == Annotating non-symbols: Attribute
  - Not everything is a variable! Most things in the AST are just nodes
  - However, you still need to annotate them with types! Remember the structure of the type checking rule - you need to be able to check the type of the child nodes before checking a type of a parent!
  - For these types *you need to set the* ```cpp p->m_attribute.m_basetype``` to the type of that node and ```cpp p->m_attribute.m_scope``` to the scope of the node.  For example
  ```cpp
    IntLit* p = /* ... */;
    // set the type of p
    p->m_attribute.m_basetype = bt_integer;
  ```
  
  ]

#polylux-slide[
  == The Symbol
  - If `SymTab` maps a name to a `Symbol`, what's a `Symbol`?
  - A `Symbol` *contains the type information* of the name!
  - The `Symbol` is a class that contains:
    - The Base type: ```cpp Basetype m_basetype;``` 
    - These pointers are only valid if the symbol is a procedure type (`m_basetype == bt_procedure` )
      - ```cpp std::vector<Basetype> m_arg_type;```
      - The return type: ```cpp `Basetype m_return_type;```
  - Ignore any `//WRITEME:` comments in this file
  - This is also defined in `symtab.hpp`
]


#polylux-slide[
  == Traversing the AST: The Visitor Pattern
  - The _visitor pattern_ is used to _traverse the AST_ and _extract_ out type information! This means that when you visit each node - you iteratively update the type information!
    - A `Visitor` of the AST is a class that defines a `visit` function for each AST node
    - We call a visitor's `visit` function by using ```cpp void accept(Visitor *v);```.
    - The ```cpp void visit_children(Visitor *v)``` method allows you to visit (by calling their `visit` function) all of the parent's nodes children.  
]

#polylux-slide[
  == Traversing the AST: The Visitor Pattern
  - An example visitior is `ast2dot.cpp` - this _extracts_ out a `dot` file (to `stdout` or a custom file descriptor) from the AST.
  - In Functional Programming - this is a _catamorphism_ - but I won't go into that because you guys don't care.
  - Here's the paper: #link("https://maartenfokkinga.github.io/utwente/mmf91m.pdf")[Functional Programming with Bananas, Lenes, Envelopes, and Barbed Wire]
]

#polylux-slide[
  == Example: Type checking IntLit
  ```cpp 
  void visitIntLit(IntLit* p) {
    // Make sure to set the current scope of every type
    p->m_attribute.m_scope = m_st->get_scope();
    // visit the children - this implicitly type-checks all 
    // of the children node of this node
    p->visit_children(this);
    // Set the type of this node
    p->m_attribute.m_basetype = bt_integer;
    }
  ```
]


#polylux-slide[
  == Example: Adding a name to the symbol table
  ```cpp
  void visitMysteryNode(MysteryNode *p) {
    // Make sure that you duplicate the string 
    char* name = strdup(p->spelling());
    s = new Symbol();
    s->m_basetype = /* ... */;
    if (!m_st->insert(name, s)) {
      /* throw error, see the errortype enum */
      this->t_error(no_main,  p->m_attribute);
    }
  }
  ```

]


#polylux-slide[
  == Scopes
  - When you introduce a new code block, that introduces a new scope!
  - This means that any variables in that scope are only valid _inside the scope_ and need to be cleaned up when you leave the scope!
  - The `SymTab` class defines functions for dealing with this!
    - Get the current scope: ```cpp SymScope* get_scope()```
    - Open the scope: ```cpp void open_scope()```
    - Close the scope: ```cpp void close_scope()```
  - When you enter a new scope, make sure to call `m_st->open_scope()`, and when you exit the scope, call `close_scope()`. 
]

#polylux-slide[
  == Debugging and Invariants
  - Again - use GDB for debugging segfaults (or if you have some unexpected behavior).
  - You can also `dump` the symbol table into a file! This is done using the ```cpp     void dump(FILE* f);``` function in `Symtab`. If you don't know what a file descriptor is, see: https://www.geeksforgeeks.org/data-type-file-c/ .
  - *Make sure to read the comments* in `symtab.hpp` *very carefully*.
  - Each method *expects invariants* (things to be true as a precondition) before calling that method! Make sure you *don't break those invariants*.
]
