#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= System design <sec:design>

#option-style(type:option.type)[
In this section you turn your requirements into a concrete engineering blueprint. You’ll justify every major architectural choice, visualize structure with C4 diagrams for the first three layers, and map out your runtime topology so that peers can understand—and you can defend—every aspect of your system.

+ Clarify how functional and non-functional requirements drive your high-level architecture
+ List each architectural decision (for example, “We chose microservices to enable independent scaling and deployment”) and explain why it best meets your goals
+ Include a C4 Context diagram showing your system in its environment (users, external systems, data sources)
+ Include a C4 Container diagram breaking the system into deployable units (APIs, web front end, background workers, databases) and annotate communication styles and protocols
+ Include a C4 Component diagram for your core container(s), illustrating key modules, services or libraries and their interactions
+ Describe your deployment topology: physical or cloud hosts, network zones, load-balancing, failover and backup strategies
+ Summarize your technology stack, mapping each tool or framework back to a specific container or component and noting any trade-offs (performance, community support, learning curve)
+ Outline how data flows through the system—including storage models, messaging patterns or API contracts—and note any schema or interface versioning plans
+ Address cross-cutting concerns (Security, Logging, Monitoring, Scalability) and show where they sit in your topology

By walking through Requirements → Decisions → Diagrams → Topology, your Design section becomes a rigorous, evidence-backed foundation for the implementation that follows.

]

== Requirements and constraints
// Derive the design requirements from the attack: a controllable replay delay that can be set
// above the target's CP duration, enough bandwidth to cover the signal, and a memory depth that
// bounds the maximum delay. Express each as a number tied to the target (the delay must exceed the
// CP, which is on the order of a few microseconds).
//
// Moved from intro 1.1 (P6) -- requirements that drive the platform choice (see also 3.2):
// "DRFM imposes constraints on the device: minimal processing latency (order of microseconds) so it
// can act in the RF environment, and a large amount of memory because big delays demand a lot of
// stored data. Modern FPGAs allow almost arbitrary signal processing with predetermined latency,
// which also helps when adapting the attack to different protocols."

== Platform and framework selection
// Justify the USRP X310 and RFNoC against the alternatives (host-based processing, RFSoC), naming
// the discarded options and the reason each was rejected. The deciding factors are deterministic
// FPGA latency, the 1 GiB DRAM for delay depth, and RFNoC's GRC-to-bitstream workflow.

== Signal chain architecture
// Present the end-to-end chain at block level: receive, store-and-delay, retransmit, with the delay
// line as the one custom element among stock RFNoC blocks. Place a block diagram here, with the
// clock domains and sample format (sc16) marked.

== Delay-line approach
// Explain the delay mechanism and the design decision behind it: the move from the early
// circular-buffer line to a DRAM-backed FIFO, and why depth drove that choice. Give the
// delay-versus-sample-rate budget so the reader sees the maximum achievable delay for a given bandwidth.

== Summary
// Restate the chosen architecture and the requirements it satisfies in a short paragraph, and point
// forward to the implementation. No new material.
