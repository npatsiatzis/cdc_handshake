![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/coverage_pyuvm.yml/badge.svg)

### RTL implementation of handshake methods for CDC of data buses (multi-bit signals)


- used for communicating data between 2 asynchronous clock domains
- Closed-Loop sampling (implements an acknowledge protocol at CDC boundary)
- Accomodates the data crossing irrespective of frequecy/phase difference between the domains
- Suffers from greater latency compared to other methods

- run pyuvm testbench
    - $ make
- run unit testing of the pyuvm testbench
    - $  SIM=ghdl pytest -n auto -o log_cli=True --junitxml=test-results.xml --cocotbxml=test-cocotb.xml

