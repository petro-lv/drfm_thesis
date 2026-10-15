#import "@preview/hei-synd-thesis:0.1.1": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("introduction-title", lang:option.lang) <sec:intro>
#set par(
  first-line-indent: 1em,
  spacing: 1em,
  justify: true,
)
== Background
Modern wireless communication systems have become an essential part for numerous technologies and applications in todays world ranging from Wi-Fi, LTE, Digital Television, satellite links to, whats important in the context of this thesis, UAV video and control links. All these applications have their specific requirements but common to most of them has always been the ability to send and receive data at very high bitrate while using spectrum bandwidth as effectively as possible. This requirement is usually satisfied by using modulation technique called Orthogonal Frequency Division Multiplexing (OFDM) as the backbone for these applications. 

When compared to different modulation techniques, OFDM still has its tradeoffs, but thanks to its benefits it has become quite common solution in high-throughput applications. At the same time, such wide adoption of OFDM implies extensive usage in critical and military infrastructure which raises an important question regarding its safety and resilience to jamming.

OFDM robustness is an actively researched subject. Over the years developers have established some standard approaches to make it work in congested or adversary environments and they perform well but the protocol is still susceptible to specific attacks targeting its inherent vulnerabilities. Different attacks are compared by J/S ratio while simple barrage jamming is deemed as a baseline in this comparison. So the most effective attack is the one with lowest J/S ratio meaning it uses the smallest amount of power to completely disrupt communication or make Bit Error Rate (BER) unacceptable. 

Considering different possible options for jamming OFDM transceivers, specifically in the case of fast moving platforms, the one constructed to look like some extreme case of multipath reflection to the transceiver looks very promising. It is relatively simple to implement from the software point of view because in essence the device capable of such an attack is pure radio repeater with, maybe, capability to do some additional signal processing. While being not that sophisticated, this approach is very effective at harnessing vulnerabilities of the protocol. Even without deliberate attacks, plain OFDM is really sensitive to multipath reflections and this weak spot is what mainly led to development of Coded-Orthogonal-Frequency-Division-Multiplexing (COFDM) which is used in field-deployed solutions.

Above mentioned attack fits well into Digital Radio Frequency Memory (DRFM) framework, which covers recording RF signal, modifying amplitude, phase or frequency and then retransmitting it with controllable delay. DRFM is quite established technology in radar deception field and respective devices for this task but, while being perfect for generating synthetic multipath reflections, its usage for disrupting OFDM communication remains limited in research community.

DRFM framework imposes certain constraints on the device its implemented on, most significant of them being minimal processing latency, on the order of nanoseconds, so it is able to act in RF environment and large amount of memory because big delays demand a lot of data to be stored. These requirements moves the choice of the platform towards Software Defined Radio (SDR) platform with Field-Programmable Gate Array (FPGA) and external memory with high throughput onboard. Modern FPGAs allow implementing almost arbitrary signal processing algorithms with predetermined latency which is also very beneficial when adapting this type of attack to different protocols.

== Related Work
Due to such popularity of OFDM in modern communication systems, efficient OFDM jamming and its resilience to these methods is being actively investigated in research community.

Full systematic analysis of modern jamming approaches is presented in @pirayesh2022jamming. In it the author classified attacks on different communication systems (WLAN, cellular, cognitive radio networks etc.) in distinctive categories and compared them by effectiveness and energy consumption. Among different techniques, attack on Cyclic Prefix (CP) specifically is also analysed. Although this attack is aimed at the vulnerability of the protocol introduced by the CP, like the one validated in this thesis, its main idea is that jammer is only radiating power when CP is being transmitted and is silent at every other moment in time and by doing so it achieves greater energy efficiency over simple barrage jamming because CP is more important to the protocol correct functioning than some portion of subcarriers transmitting actual data.

Over the years there were number of attacks invented and checked specifically against OFDM, some of them are aimed at preamble, pilot tones or CP. These were reviewed in detail in @lichtman2016lte, @shahriar2015ofdm. A lot of them require some complex synchronisation or extensive knowledge of underlying protocol and waveform parameters. But on the contrary, so-called repeater attack is much less demanding to all of those. 

Thus, in @li2017cpjamming the author focused on this type of attack only and used DRFM techniques to disrupt communication by degrading CP functionality. Attack scheme offered is the one in which jammer is supposed to capture and then retransmit OFDM frame with a delay exceeding CP lenght and make assumption of subcarriers orthogonality fail while staying invisible to receiver by resembling one of multipath reflections to it. This type of attack really proved to be effective at degrading performance of the system by making BER higher with varying delay of retransmitting, although all of results were obtained in simulated environment only.

Miminal fully-functioning example of a DRFM system capable of frequency and phase shift of a recorded signal is presented in @mesarcik2019drfm. What is even more interesting about this particular implementation is that it was done with the help of relatively cheap Commercial off-the-shelf (COTS) FPGA. This fact highlights growing availability of DRFM research to broad audience, all thanks to modern FPGAs cost and capabilities.

This analysis proves that while a lot of research is being done on jamming OFDM links and abusing its weak spots, vulnerability to complex multipath reflection scenarios introduced by CP is not investigated enough. Although DRFM framework is perfect candidate for creating such difficult conditions for OFDM-based systems, its role in modern attack schemes is quite modest and its efficiency is barely checked in real RF environments with commercial protocols. On the other hand, DRFM is viewed mainly as an instrument to radar deception which it was originally created for.

== Research goals
This thesis is aimed to prove efficiency of DRFM-based jamming against OcuSync protocol used in Mavic UAV. The goals of are: 

+ DRFM system implementation on SDR X-310
+ System efficiency comparison with barrage jamming