# installation

install the following packages (on Debian)
make yosys nextpnr-ice40 fpga-icestorm openfpgaloader

# building

build the design with

```bash
make
```

# program

```
openFPGALoader -b ice40_generic blinky.bin
```
