# CIRCT and Yosys interoperability

This is a mockup integration of CIRCT and Yosys. By directly integrating both tools, the intermediate setup with Verilot files is not needed.

```mermaid
  graph TD;
      Chisel-->Core Dialects;
      Core Dialects-->RTL IL Dialect;
      RTL IL Dialect-->RTL IL;
      RTL IL-->Yosys;
```

