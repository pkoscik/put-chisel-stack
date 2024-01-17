FPGA_PKG = tq144
FPGA_TYPE = hx1k
PCF = Blinky.pcf

# included modules
PRJ_NAME = Blinky

VERILOG_SRCS = Blinky.sv

all: $(PRJ_NAME).bin

$(PRJ_NAME).json: $(VERILOG_SRCS)

	yosys -ql $(basename $@)-yosys.log -p \
	    'synth_ice40 -top $(basename $@) -json $@' $< $(VERILOG_SRC)

$(PRJ_NAME).asc: $(PRJ_NAME).json

	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

$(PRJ_NAME).rpt: $(PRJ_NAME).asc

	icetime -d ${FPGA_TYPE} -mtr $@ $<

$(PRJ_NAME).bin: $(PRJ_NAME).asc

	icepack $< $(subst top_,,$@)

clean:

	rm -f *.json *.asc *.rpt *.bin *yosys.log *.v *.sv

.PHONY: all clean

