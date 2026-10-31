#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Implementation <sec:impl>

#option-style(type:option.type)[
In this section you translate your component-level designs into working code and systems. Focus on the C4 Component layer and on the details needed to show how your design was realized. Include only the most important code snippets that illustrate key patterns or algorithms, rather than full listings.

+ Describe the development methodology (for example, Agile or test-driven development) used to guide your implementation
+ Explain any prototyping or iterative strategies you applied to refine components before full-scale coding
+ Summarize coding standards, naming conventions and architectural patterns followed in your codebase
+ Present critical code snippets or configuration templates that highlight how core components were implemented (for example, key classes, interfaces or algorithms)
+ Detail your testing approach and quality assurance measures (unit tests, integration tests, coverage metrics)
+ Note any performance optimizations or profiling results for components that were bottlenecks
+ Outline your deployment and configuration management process for component artifacts (containerization, CI/CD pipelines)
+ Highlight documentation deliverables (API references, inline comments, architecture decision records) that support future maintenance

This section demonstrates how each component specification becomes actual, maintainable code—closing the loop from design to implementation.
]

== RFNoC module and block
// Describe the `drfm` out-of-tree module and its single `delay` block, and how it sits in the RFNoC
// graph. State the interfaces: the sc16 input and output streams and the control-port register that
// carries the delay value.
//
// --- Paragraph plan (expand each bullet into 2-4 sentences) ---
// P1 (what the module is). One short paragraph: `rfnoc-drfm` is an out-of-tree (OOT) RFNoC module
//    built from the UHD OOT template; it ships one processing block, `delay`. Say where it lives in
//    the tree (HDL in rfnoc/fpga/drfm/rfnoc_block_delay, C++ control in lib/, GRC binding in grc/).
// P2 (the block's place in the graph). One paragraph: the block is a single-in/single-out element
//    that drops into the RFNoC graph between the radio's RX and TX DUCs/DDCs. Point the reader to
//    @fig:rfnoc-image below for the full image graph.
// P3 (interfaces -- the contract). One paragraph, three concrete facts:
//    - data: one sc16 input stream and one sc16 output stream (complex int16, i.e. 32 bits/sample);
//    - control: a single control-port register at address 0x0 ("REG_DELAY") carrying the delay in
//      samples as a uint32;
//    - identity: registered as NoC-ID 0xDE1A0001 under the name "Delay".
//    This paragraph is the hinge into 4.2 (how the register is used) and 4.3 (how it is driven).
#figure(
  image("/resources/img/image_for_drfm_noise_power_measurement.png", width: 14cm),
  caption: [RFNoC image graph built for the X310: the #raw("delay") block
    in the processing chain, with its DRAM port wired to the BSP.],
) <fig:rfnoc-image>

== DRAM-backed delay line
// Explain how the block uses UHD's `axi_ram_fifo` over the X310's 1 GiB DRAM to hold samples and
// release each one `delay` samples later, at the 300 MHz memory clock with two samples per 64-bit
// word. Include the user logic as a Listing and describe in the prose what it does (reproducibility).
//
// --- Paragraph plan ---
// P1 (the idea in one sentence). A delay line is just a FIFO you are not allowed to drain: hold each
//    sample until `delay` newer samples sit behind it, then let it out. State it this plainly first.
// P2 (why DRAM, not BRAM). The depth you need (up to MAX_DELAY = 250,000,000 samples) will not fit
//    in on-chip BRAM, so the line is backed by one of the X310's 1 GiB DDR3 DRAM ports. Name the
//    building block: UHD's `axi_ram_fifo`, instantiated on DRAM port 0 (FIFO_ADDR_MASK = all 1 GiB).
//    (This is the design decision whose justification lives in 3.4 -- here just state what was built.)
// P3 (the numbers that bound it). Three facts, each with its HDL constant so the build is reproducible:
//    - MEM_ADDR_W = 30 -> 1 GiB per DRAM port;
//    - MEM_DATA_W = 64 -> two sc16 samples per 64-bit word;
//    - everything runs on mem_clk, which is also ctrlport_clk and axis_data_clk (one clock domain --
//      say this, it is why there is no CDC to worry about).
//    From these, derive the depth->max-delay-in-time relation and forward-reference the budget in 3.4.
// P4 (the Listing). Include the user-logic block (the part after `// User Logic: DRAM delay line`,
//    ~40 lines: the delay register, the +1/+2/+4 pipelined thresholds, and the axi_ram_fifo
//    instantiation) as a numbered Listing. In prose, walk the reader through what the gating logic
//    does -- do NOT make them read the Verilog to understand it.

== Runtime delay control
// Describe how the delay property is exposed so it can be changed from GRC while the flowgraph runs,
// and the register path that carries it to the FPGA. Note any constraint, such as the maximum delay
// and how out-of-range values are clamped.
//
// --- Paragraph plan ---
// P1 (the control path, top to bottom). Trace one number from the knob to the FPGA:
//    GRC "Delay (samples)" field -> set_property('delay', ...) on the block -> C++ property
//    resolver in delay_block_control -> poke32(REG_DELAY, delay) -> the 0x0 register the HDL reads.
//    This is why the delay can be changed live while the flowgraph runs (used in the sweep in Ch.5).
// P2 (clamping / safety). State the one constraint and that it is enforced twice: the C++ resolver
//    clamps to [0, MAX_DELAY] before poking, and the HDL independently clamps anything > MAX_DELAY.
//    Give MAX_DELAY = 250,000,000 samples and convert it to a max delay time at your sample rate.
// P3 (behaviour on a live change -- the honest caveat). From the block YAML: raising the delay pauses
//    the output until the line refills; lowering it drops samples. Say this plainly -- it matters for
//    how the Chapter 5 sweep is run (settle between points) and is a limitation, not a bug.

== Build and integration workflow
// Document the path from the GRC graph through the RFNoC Image Builder to the bitfile, and the
// loading of the image onto the radio. Give the exact commands and tool versions, or point to the
// appendix that does, so the build can be repeated.
//
// --- Paragraph plan ---
// P1 (the pipeline). One paragraph naming each stage: GRC image-graph (icores/x310_drfm.grc) ->
//    RFNoC Image Builder -> Vivado synthesis/P&R -> X310 bitfile -> loaded with uhd_image_loader.
//    Keep it a narrative; the exact commands and tool versions (UHD x.y, Vivado 20xx.z) go in an
//    appendix you cite here, so the chapter stays readable and the build stays reproducible.
// P2 (verification that the build is real). One or two sentences: the block has a C++ unit test
//    (lib tests/delay_block_test) and an HDL testbench (rfnoc_block_delay_tb.sv / sim/tb_delay.sv)
//    that confirm the delay value before anything is flashed to the radio. (Fuller results in Ch.5.)

== Summary
// Summarise the working block and what it does, and name any limitation carried into the experiments
// (for example, the latency floor or the delay range). Point forward to validation.
//
// --- Paragraph plan (one short paragraph, no new material) ---
// - One sentence: what now exists -- a runtime-controllable DRAM-backed delay line as a single RFNoC
//   block on the X310, delay settable 0..MAX_DELAY samples.
// - One sentence: the limitation carried into Ch.5 -- e.g. the refill pause on a delay increase, and
//   the max delay / bandwidth trade-off from 3.4.
// - One sentence: forward pointer to validation (does this replica actually beat barrage jamming?).
