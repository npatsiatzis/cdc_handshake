### RTL implementation of handshake methods for CDC of data buses (multi-bit signals)


- used for communicating data between 2 asynchronous clock domains
- Closed-Loop sampling (implements an acknowledge protocol at CDC boundary)
- Accomodates the data crossing irrespective of frequecy/phase difference between the domains
- Suffers from greater latency compared to other methods

-- Verilator tb for functional verification, adapted from the work of Norbet Kremeris (https://www.itsembedded.com/dhd/verilator_4/). Added coverage class for the input and output interfaces,sequence class, coverage-based end-of-test condition and coverage-driven test generation
-- Verilator support for multiple clock domains adopted from https://josuah.net/blog/2022-05-18/.

- run sim
    - $ make sim
- Achieve full point coverage for output
- open waveform with gtkwave
    - $ make waves
- lint test
    - $make lint
