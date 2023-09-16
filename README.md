![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/coverage_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/regression.yml/badge.svg)
[![codecov](https://codecov.io/gh/npatsiatzis/cdc_handshake/graph/badge.svg?token=V32Y6588S0)](https://codecov.io/gh/npatsiatzis/cdc_handshake)

### RTL implementation of handshake methods for CDC of data buses (multi-bit signals)


- used for communicating data between 2 asynchronous clock domains
- Closed-Loop sampling (implements an acknowledge protocol at CDC boundary)
- Accomodates the data crossing irrespective of frequecy/phase difference between the domains
- Suffers from greater latency compared to other methods



| Folder | Description |
| ------ | ------ |
| [rtl/SystemVerilog](https://github.com/npatsiatzis/cdc_handshake/tree/main/rtl/SystemVerilog) | SV RTL implementation files |
| [rtl/VHDL](https://github.com/npatsiatzis/cdc_handshake/tree/main/rtl/VHDL) | VHDL RTL implementation files |
| [cocotb_sim](https://github.com/npatsiatzis/cdc_handshake/tree/main/cocotb_sim) | Functional Verification with CoCoTB (Python-based) |
| [pyuvm_sim](https://github.com/npatsiatzis/cdc_handshake/tree/main/pyuvm_sim) | Functional Verification with pyUVM (Python impl. of UVM standard) |
| [uvm_sim](https://github.com/npatsiatzis/cdc_handshake/tree/main/uvm_sim) | Functional Verification with UVM (SV impl. of UVM standard) |
| [verilator_sim](https://github.com/npatsiatzis/cdc_handshake/tree/main/verilator_sim) | Functional Verification with Verilator (C++ based) |



This is the tree view of the strcture of the repo.
<pre>
<font size = "2">
.
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/rtl">rtl</a></b> </font>
│   ├── <font size = "4"><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/rtl/SystemVerilog">SystemVerilog</a> </font>
│   │   └── SV files
│   └── <font size = "4"><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/rtl/VHDL">VHDL</a> </font>
│       └── VHD files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/cocotb_sim">cocotb_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a 
 href="https://github.com/npatsiatzis/cdc_handshake/tree/main/pyuvm_sim">pyuvm_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/uvm_sim">uvm_sim</a></b></font>
│   └── .zip file
└── <font size = "4"><b><a href="https://github.com/npatsiatzis/cdc_handshake/tree/main/verilator_sim">verilator_sim</a></b></font>
    ├── Makefile
    └── verilator tb

</pre>