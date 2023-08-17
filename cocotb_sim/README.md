![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/cdc_handshake/actions/workflows/coverage.yml/badge.svg)

### RTL implementation of handshake methods for CDC of data buses (multi-bit signals)


- used for communicating data between 2 asynchronous clock domains
- Closed-Loop sampling (implements an acknowledge protocol at CDC boundary)
- Accomodates the data crossing irrespective of frequecy/phase difference between the domains
- Suffers from greater latency compared to other methods
- CoCoTB testbench for functional verification

