This directory contains the *.S (Starup file) pointing to an initial register to instantiate a program counter and contains an Assembly code to define the operations in the CPU

```bash
riscv-none-elf-as boot.s -o boot.o
riscv-none-elf-ld boot.o -Ttext=0x0 -o boot.elf
riscv-none-elf-objcopy -0 binary boot.elf boot.bin
```

After compiling the code for RISCV, generate the hex file by simply running the python script ```hex_gen.py```
