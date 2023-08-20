# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

# use VHDL_SOURCES for VHDL files
VHDL_SOURCES += $(PWD)/../rtl/VHDL/*.vhd

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file

4phase:
		rm -rf sim_build
		$(MAKE) sim MODULE=tb_$@ TOPLEVEL=cdc_$@
2phase:
		rm -rf sim_build
		$(MAKE) sim MODULE=tb_$@ TOPLEVEL=cdc_$@

clean_dir:
		rm -f wave.*
		rm -f *.o 
		rm -f *.xml
		find . -maxdepth 1 -type f -executable -exec rm {} +
		find -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 rm -R
# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim