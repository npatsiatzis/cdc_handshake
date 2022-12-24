# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

VHDL_SOURCES += $(PWD)/ff_synchronizer.vhd
VHDL_SOURCES += $(PWD)/cdc_4phase.vhd
VHDL_SOURCES += $(PWD)/cdc_2phase.vhd
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file

test:
		rm -rf sim_build
		$(MAKE) sim MODULE=testbench_4phase TOPLEVEL=cdc_4phase

test_2phase:
		rm -rf sim_build
		$(MAKE) sim MODULE=testbench_2phase TOPLEVEL=cdc_2phase

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim