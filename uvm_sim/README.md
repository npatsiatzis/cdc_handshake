### RTL implementation of handshake methods for CDC of data buses (multi-bit signals)

- used for communicating data between 2 asynchronous clock domains
- Closed-Loop sampling (implements an acknowledge protocol at CDC boundary)
- Accomodates the data crossing irrespective of frequecy/phase difference between the domains
- Suffers from greater latency compared to other methods

- Link to the playground : https://www.edaplayground.com/x/stWE (4phase)
- Link to the playground : https://www.edaplayground.com/x/P2Kv (2phase)
- Make sure that "Use run.do Tcl file" and "Download files after run" options remain checked 
- results.zip is downloaded at the end of the execution
    - contains all the SV/UVM tb files, coverage information etc...
    