# RV32I Soft-Core CPU (Verilog 2001)

A minimal, modular, and simulation-ready RISC-V RV32I-compatible processor core written in **pure Verilog 2001**, designed and verified by [@Sujith](https://github.com/yourusername). This soft-core supports key RV32I instructions and executes programs loaded via a `.hex` memory file — validated through waveform and memory inspection.

> ✅ Zero SystemVerilog.  
> ✅ Fully modular.  
> ✅ Instruction and data memory support.  
> ✅ Executes RISC-V assembly via `.hex`.  
> ✅ Synthesizable and FPGA-friendly.

---

## 🚀 Features

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

## 📁 Directory Structure

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
├── prog/
│   ├── main.S         # Sample program (add x1 and x2, store to mem)
│   └── gen_hex.sh     # Use RISC-V GNU toolchain to build boot.hex
└── README.md
