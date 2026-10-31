#import "@preview/hei-synd-thesis:0.1.1": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("introduction-title", lang:option.lang) <sec:intro>
#set par(
  first-line-indent: 1em,
  spacing: 1em,
  justify: true,
)
== Background and motivation
// Para 1 (relevance) -- for an engineer who is not a specialist:
//   - OFDM underpins modern wireless incl. UAV video/control links; define OFDM in a few words;
//   - why it matters: wide use in critical infrastructure and public-safety networks @jarwan2019lte;
//   - add one concrete relevance number with a source (e.g. DJI ~94% consumer-drone market @schiller2023droneid);
//   - end on the question this raises: OFDM's safety and resilience to jamming.
Modern wireless communication systems have become an essential part for numerous technologies and applications in today's world ranging from Wi-Fi, LTE, Digital Television, satellite links to, what's important in the context of this thesis, UAV video and control links. All these applications have their specific requirements but common to most of them has always been the ability to send and receive data at very high bitrate while using spectrum bandwidth as effectively as possible. This requirement is usually what leads developers to using modulation technique called Orthogonal Frequency Division Multiplexing (OFDM) for these applications.
At the same time, such wide adoption of OFDM implies extensive usage in critical and military infrastructure @jarwan2019lte which raises an important question regarding its safety and resilience to jamming.@schiller2023droneid

// Para 2 (attack landscape -> chosen attack).
// First, the landscape: OFDM is attacked at the PHY; attacks are compared by J/S against a barrage
// baseline @pirayesh2022jamming @lichtman2016taxonomy (the full J/S definition lives in 5.1).
// Then the chosen attack:
//   - name it: a repeater / delayed-replica jammer that captures the OFDM signal and retransmits it
//     after a controllable delay (not a noise jammer);
//   - why it beats the surveyed attacks: needs no frame sync and no protocol knowledge, only the
//     carrier and the CP length, and the receiver cannot tell the replica from a natural echo;
//   - mechanism in one sentence: a replay delay larger than the CP breaks subcarrier orthogonality,
//     so the BER rises with the delay;
//   - replace "looks very promising"/"very effective" with one measured result + condition (Li's
//     BER-vs-delay, simulated Wi-Fi) @li2017cpjamming;
//   - keep the COFDM point: plain OFDM's multipath sensitivity motivated coded OFDM, foreshadowing
//     that OcuSync is coded -- the risk Chapter 5 tests;
//   - impersonal register, no "maybe", no unquantified adjectives.
OFDM robustness is an actively researched subject. Over the years developers have established some standard approaches to make it work in congested or adversary environments and they perform well but the protocol is still susceptible to specific attacks targeting its inherent vulnerabilities. Different attacks are compared by J/S ratio while simple barrage jamming is deemed as a baseline in this comparison @pirayesh2022jamming.
Considering different possible options for jamming OFDM transceivers, specifically in the case of fast moving platforms, the one constructed to look like some extreme case of multipath reflection to the transceiver looks very promising. It is relatively simple to implement from the software point of view because in essence the device capable of such an attack is pure radio repeater with, maybe, capability to do some additional signal processing. While being not that sophisticated, this approach is very effective at harnessing vulnerabilities of the protocol. Even without deliberate attacks, plain OFDM is really sensitive to multipath reflections and this weak spot is what mainly led to development of Coded-Orthogonal-Frequency-Division-Multiplexing (COFDM) which is used in field-deployed solutions.

// Para 3 (DRFM and the gap). Define DRFM in one line (record -> modify -> retransmit with delay) and
// give its radar-deception origin @roome1990drfm @mesarcik2019drfm. Then state the gap this thesis
// fills: the replica/CP attack has been shown only in simulation, not over the air against a
// commercial coded link @li2017cpjamming. This sentence is the hinge into 1.2 (Objectives).
Above mentioned attack fits well into Digital Radio Frequency Memory (DRFM) framework, which covers recording RF signal, modifying amplitude, phase or frequency and then retransmitting it with controllable delay. DRFM is quite established technology in radar deception field @roome1990drfm and respective devices for this task but, while being perfect for generating synthetic multipath reflections, its usage for disrupting OFDM communication remains limited in research community @li2017cpjamming.

// Para 4 (feasibility bridge). Say only that such a delay line is now practical on an SDR with an
// FPGA and high-throughput memory, handing off to the objectives in 1.2. (Requirements detail lives
// in 3.1/3.2.) As a lone one-sentence paragraph it breaks Tampere's >=2-sentences rule: add a second
// sentence or fold it into Para 3.
Such a delay line is now practical on a Software Defined Radio (SDR) with a Field-Programmable Gate Array (FPGA) and high-throughput external memory, which motivates the platform chosen in this work.

== Objectives and contribution
// Give the aim in a single sentence, then list the two to four things actually delivered: the RFNoC
// delay-line block, the measurement method, the over-the-air comparison. Place the orientation
// figure near here (the jammer in its signal chain, inputs/outputs marked, contribution highlighted).
// TODO: consider reframing "prove efficiency" as "measure whether the replica beats barrage" so the
// aim is a hypothesis that can fail (see H1/H2 in Subchapter 2.6).
This thesis is aimed to prove efficiency of DRFM-based jamming against OcuSync protocol used in Mavic UAV. The goals of are:

+ DRFM system implementation on SDR X-310
+ System efficiency comparison with barrage jamming

== Structure of the thesis
// Do not restate the contents page. This subsection earns its place two ways the table of contents
// cannot: it gives the logical thread in a sentence or two (the gap in Chapter 2 motivates the
// design in Chapter 3, which is built in Chapter 4 and measured against barrage jamming in Chapter 5),
// and it carries the orientation figure the guide asks every introduction to open with: the jammer
// in its RX -> delay -> TX signal chain, inputs and outputs marked, your own contribution highlighted.
// Keep the prose to one short paragraph; the figure does the work.

// NOTE: the former "Related Work" prose was moved to Chapter 2 (Domain analysis, sec:analysis).
