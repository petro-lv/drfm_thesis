#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Validation and results <sec:validation>

#option-style(type:option.type)[
Validation (Requirements Verification and Testing)

In this section you demonstrate how your implementation satisfies the initial requirements through clear testing methods and concise examples—suitable for a bachelor-level project:

+ Restate each key functional and non-functional requirement from your Analysis and Design sections
+ Describe the testing approach for each requirement (for example, unit tests, manual acceptance checks or scenario walkthroughs)
+ Provide concrete test cases or usage examples that show how you verify each requirement in practice
+ Summarize actual versus expected outcomes, indicating pass/fail status for each test
+ Include brief snippets of test code or sample console outputs to illustrate your procedures
+ Note any gaps or deviations and suggest simple fixes or areas for future improvement
+ If a feature wasn’t intended for specific scenarios (e.g. high-load), omit unrealistic stress tests and clearly document its current limitations

This focused structure ties every requirement directly to validation results, using examples and methods you can realistically carry out at the bachelor level.

]

== Evaluation method and metrics
// Define exactly what you measure and how: the J/S definition, the link-quality proxy (video
// bitrate, frame or packet loss, link-loss events, since the drone's BER is not directly readable),
// and how operating points are fixed before the test. State the controlled RF environment used,
// because transmitting these signals over the air is otherwise not permitted.
//
// Moved from intro 1.1 (P3) -- fold into the J/S metric definition:
// "The most effective attack is the one with the lowest J/S ratio, meaning it uses the smallest
// amount of power to completely disrupt communication or make the Bit Error Rate (BER) unacceptable."

== Delay-line functional verification
// Show that the block delays samples correctly in loopback and in the testbench, with a figure
// comparing input and delayed output. This establishes that the instrument works before you draw
// any conclusion from it.

== Cyclic-prefix attack in simulation
// Reproduce the reference result (Li et al.) on your own uncoded OFDM waveform in GNU Radio, giving
// the BER-versus-delay curve. This validates the whole chain against the literature and is the
// safety-net result if the OcuSync experiment is inconclusive.

== Over-the-air jamming experiment
// First report the measured OcuSync waveform parameters (this fills the gap left in Subchapter 2.5),
// then present what happens to the link as the replay delay crosses the measured CP duration.
// Describe the setup in enough detail to repeat it.

== Comparison with barrage jamming
// Present the J/S the replica needs against the J/S barrage needs for the same link degradation, by
// condition (tests H1). Include the delay-versus-power control (H2): a replica with delay below the
// CP at the same power, to separate the effect of the delay from the effect of the added energy.
