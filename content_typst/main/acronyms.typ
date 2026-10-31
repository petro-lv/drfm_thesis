#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
#heading(numbering: none, outlined: false)[List of Acronyms]

#table(
  columns: (auto, 1fr),
  stroke: none,
  align: (left, left),
  inset: (x: 0.4em, y: 0.6em),
  table.hline(stroke: 0.8pt),
  table.header([*Acronym*], [*Definition*]),
  table.hline(stroke: 0.5pt),
  [BER],   [Bit Error Rate],
  [COFDM], [Coded Orthogonal Frequency-Division Multiplexing],
  [COTS],  [Commercial Off-the-Shelf],
  [CP],    [Cyclic Prefix],
  [DDR],   [Double Data Rate],
  [DRAM],  [Dynamic Random-Access Memory],
  [DRFM],  [Digital Radio Frequency Memory],
  [FPGA],  [Field-Programmable Gate Array],
  [ISI],   [Intersymbol Interference],
  [J/S],   [Jamming-to-Signal Ratio],
  [LTE],   [Long-Term Evolution],
  [OFDM],  [Orthogonal Frequency-Division Multiplexing],
  [PHY],   [Physical Layer],
  [RF],    [Radio Frequency],
  [RFNoC], [RF Network-on-Chip],
  [SDR],   [Software-Defined Radio],
  [SNR],   [Signal-to-Noise Ratio],
  [SRAM],  [Static Random-Access Memory],
  [UAV],   [Unmanned Aerial Vehicle],
  [WLAN],  [Wireless Local Area Network],
  table.hline(stroke: 0.8pt),
)
