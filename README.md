# SDR-based DRFM Jammer for OFDM-PHY
## Implementation

### Hardware
This project is built around USRP X-310. A highly capable SDR with Xilinx FPGA and DDR memory onboard.

### Software
Vivado 2024.2\
Vitis\
GNU Radio

## Project Structure

The directory structure of new project looks like this:

```
├── src                    <- Source code
│   ├── delay_line               <- SRAM implementation
│   └── RFNoC_modules            <- OOT modules for DSP
└── README.md
```

## Setup and Verification

Running testbench for delay_line.sv module in vivado

Open drfm_fifo.xpr in GUI and then run in tcl console
```sh
launch simulation
```