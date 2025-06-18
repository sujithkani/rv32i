# RV32I Soft-Core CPU (Verilog 2001)

A minimal, modular, and simulation-ready RISC-V RV32I-compatible processor core written in **pure Verilog 2001**.This soft-core supports key RV32I instructions and executes programs loaded via a `.hex` memory file — validated through waveform and memory inspection.

> Fully modular.  
> Instruction and data memory support.  
> Executes RISC-V assembly via `.hex`.  
> Synthesizable and FPGA-friendly.
---

## Features

- Implements a subset of **RV32I** base instructions:
  - R-type: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`, `SLTU`
  - I-type: `ADDI`, `ANDI`, `ORI`, `XORI`, `LW`, `JALR`
  - S-type: `SW`
  - B-type: `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`
  - U-type: `LUI`, `AUIPC`
  - J-type: `JAL`
- Modular architecture: `alu.v`, `reg_file.v`, `rv32i_core.v`, `rv32i_top.v`, `simple_ram.v`
- Assembly program written in `.S`, assembled externally to `boot.hex`
- Single-cycle simulation with testbench (`tb.v`)
- Instruction/Data memories with separate address buses
- Simulation output via `$display` and waveform via `.vcd`

---

## Directory Structure

```bash
rv32i_cpu/
├── rtl/
│   ├── alu.v
│   ├── reg_file.v
│   ├── rv32i_core.v
│   ├── rv32i_top.v
│   └── simple_ram.v
├── sim/
│   ├── tb.v
│   ├── boot.hex       # Compiled RISC-V assembly program
│   └── rv32i.vcd      # Generated waveform
├── fw/
│   ├── boot.S         # Sample program (add x1 and x2, store to mem)
│   └── gen_hex.py     # Build boot.hex
└── README.md
```
---

## Running the design
  - Extract the repository in a location.
  - Ensure you have ```iverilog``` added to the path.
  - Navigate to the directory containing the testbench: ```tb.v```
  - From that directory, run ```iverilog -o rv32i_sim ../rtl/*.v tb.v```
  - Once the compilation is done, execute by ```vvp rv32i_sim``` in the same directory to see the program result.
---

# Limitations
  - No pipeline (single-cycle model).
  - No floating-point support.
  - No support for multiply/divide operations (Can be implemeted through loops in the .asm code)
  - No CSR or interrupt handling.
  - Limited to simulation for now.
