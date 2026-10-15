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
  [DRFM], [Digital Radio Frequency Memory],
  [FPGA], [Field-Programmable Gate Array],
  [OFDM], [Orthogonal Frequency-Division Multiplexing],
  [DDR],  [Double Data Rate],
  [SDR],  [Software-Defined Radio],
  [SRAM], [Static Random-Access Memory],
  [DRAM], [Dynamic Random-Access Memory],
  [BER],  [Bit Error Rate],
  [SNR],  [Signal-to-Noise Ratio],
  [PHY],  [Physical Layer],
  [ISI],  [Intersymbol Interference],
  [J/S ratio], [Jamming-to-Signal ratio],
  [BER], [Bit Error Rate],
  table.hline(stroke: 0.8pt),
)