#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= Domain analysis <sec:analysis>

#option-style(type:option.type)[
  In this section, you perform a State of the Art investigation of your domain to understand what’s been built, how it works, and where it falls short. You’ll survey existing solutions—tools, frameworks and approaches—then compare them against your project’s requirements to justify why a new tool (and its specific feature set) is needed.

A focused Domain Area Research unfolds in these steps:

+ Clarify your research questions and functional requirements
+ Collect and review candidate solutions
+ Evaluate each alternative’s strengths, weaknesses, maturity and architectural style
+ Group similar approaches into meaningful categories (for example, monolithic vs. microservice, commercial vs. open-source)
+ Pinpoint gaps or missing features that motivate your own design

This process carries your initial concept through systematic research all the way to a clear, actionable set of requirements for your proposed tool.
]

== OFDM and the cyclic prefix
When compared to different modulation techniques, OFDM still has its tradeoffs, but thanks to its benefits it has become quite common solution in high-throughput applications.
// Define OFDM, subcarrier orthogonality and the role of the CP in absorbing multipath delay spread,
// written for an engineer who is not a specialist. State the condition the CP must satisfy
// (CP length >= channel delay spread), because every attack in this chapter works by breaking it.

#figure(
  image("/resources/img/ofdm_frame.png", width: 15cm),
  caption: [OFDM frame structure: three sequential OFDM symbols with $K$
     subcarriers, each starting with CP
     (source: @ucuncu2015ofdm)]
)

// Orthogonal Frequency Division Multiplexing (OFDM) is one of the main building blocks for modern wireless communication systems PHY-layer --- Wi-Fi, LTE, 5G, digital TV and whats more important in the context of this thesis, communication systems for UAV, also specifically, Ocusync для Mavic. Принцип OFDM полягає в поділі широкосмугового каналу на велику кількість ортогональних вузькосмугових піднесучих, кожна з яких модулюється незалежно. Такий підхід забезпечує високу спектральну ефективність та стійкість до частотно-селективного завмирання (frequency selective fading). Також у каналах зв'язку присутня проблема викликана багатопроменевим поширенням (multipath propagation), цей ефект спричиняє те, що у канал приймача приходять кілька затриманих у часі копій сигналу і призводить до ISI. Одним із ключовиx елементів, що забезпечує стійкість OFDM до ISI є циклічний префікс (CP). CP формується копіюванням з кінця деякої частини OFDM-символу та додаванням її на початок як захисного інтервалу. Довжина CP обирається більшою за максимальну затримку багатопроменевого поширення в каналі. Якщо ця умова дотримана, то лінійна згортка сигналу з імпульсною характеристикою каналу перетворюється на циклічну, що зберігає ортогональність піднесучих та дозволяє приймачу відновити символи. Таким чином, CP усуває ISI знижуючи пропускну здатність. Саме ця роль CP спричиняє вразливість OFDM-систем, яку буде розглянуто далі.

== Jamming of OFDM systems
// Survey the attack families (barrage, pilot jamming/nulling, preamble and synchronisation,
// off-tone) and introduce J/S relative to barrage as the yardstick that ranks them. Close with the
// comparison table of what each attack demands of the jammer, so the reader sees why a replica,
// which needs no synchronisation, stands out. (See tab:ofdm-attacks in the reworked draft.)

// --- Draft moved from the former intro "Related Work"; split across 2.2-2.4 and reconcile with the
//     reworked state-of-the-art text offered separately. ---
Due to such popularity of OFDM in modern communication systems, efficient OFDM jamming and its resilience to these methods is being actively investigated in research community.

Full systematic analysis of modern jamming approaches is presented in @pirayesh2022jamming. In it the author classified attacks on different communication systems (WLAN, cellular, cognitive radio networks etc.) in distinctive categories and compared them by effectiveness and energy consumption. Among different techniques, attack on Cyclic Prefix (CP) specifically is also analysed. Although this attack is aimed at the vulnerability of the protocol introduced by the CP, like the one validated in this thesis, its main idea is that jammer is only radiating power when CP is being transmitted and is silent at every other moment in time and by doing so it achieves greater energy efficiency over simple barrage jamming because CP is more important to the protocol correct functioning than some portion of subcarriers transmitting actual data.

Over the years there were number of attacks invented and checked specifically against OFDM, some of them are aimed at preamble, pilot tones or CP. These were reviewed in detail in @lichtman2016lte, @shahriar2015ofdm. A lot of them require some complex synchronisation or extensive knowledge of underlying protocol and waveform parameters. But on the contrary, so-called repeater attack is much less demanding to all of those.

== Repeater and replica attacks
// Frame the repeater/replica family, then present Li et al. as the point of reference: a delayed
// copy acts as a multipath component the CP can no longer cover, so orthogonality fails and the BER
// rises with delay. Reproduce their key numbers with their conditions, note the DRFM-vs-OFDM work
// (Bilodeau-Robitaille) alongside, and state plainly that both results are simulation-only.

#figure(
  image("/resources/img/ber_wifi.png", width: 12cm),
  caption: [BER vs SNR for Wi-Fi OFDM signal  for different values of delay $Delta$ (source: @li2017cpjamming)]
)

Thus, in @li2017cpjamming the author focused on this type of attack only and used DRFM techniques to disrupt communication by degrading CP functionality. Attack scheme offered is the one in which jammer is supposed to capture and then retransmit OFDM frame with a delay exceeding CP lenght and make assumption of subcarriers orthogonality fail while staying invisible to receiver by resembling one of multipath reflections to it. This type of attack really proved to be effective at degrading performance of the system by making BER higher with varying delay of retransmitting, although all of results were obtained in simulated environment only.

// Згідно з першим розділом, де описується функція CP у схемі OFDM, умовою коректного прийому сигналу без ISI є вибір довжини CP, яка буде більшою за затримки усіх копій сигналу на приймачі спричинених багатопроменевим поширенням. Якщо ця умова порушена, лінійна згортка сигналу з імпульсною характеристикою каналу перестає бути циклічною і BER починає погіршуватись, що зображено на фото вище. Саме цю вразливість можна використати застосувавши DRFM, вибравши таку затримку для відтворення сигналу, що довжини CP буде недостатньо. Дослідження показують, що атака на CP використовує потужність передавача
// ефективніше порівняно з класичним шумовим подавленням @pirayesh2022jamming, до того ж, залишається менш помітним для приймача, оскільки сприймається ним як звичайне багатопроменеве поширення @li2017cpjamming.

== Digital radio frequency memory
// Define DRFM and its radar-deception origin, then review the FPGA and SDR implementations
// (Mesarcik, the reactive jammers on USRP) that show the function is feasible on commodity hardware.
// Note the RFNoC latency figure here, as it sets the floor the design must live with.

Miminal fully-functioning example of a DRFM system capable of frequency and phase shift of a recorded signal is presented in @mesarcik2019drfm. What is even more interesting about this particular implementation is that it was done with the help of relatively cheap Commercial off-the-shelf (COTS) FPGA. This fact highlights growing availability of DRFM research to broad audience, all thanks to modern FPGAs cost and capabilities.

// Digital Radio Frequency Memory, DRFM ---
// це технологія, яка записує вхідний радіочастотний сигнал, зберігає його
// у цифровому вигляді та відтворює з контрольованою затримкою, зсувом частоти або іншою зміною сигналу.
// На відміну від звичайних генераторів
// шумових завад, DRFM формує когерентну копію оригінального сигналу, що дозволяє ефективніше
// використовувати потужність передавача і робить
// її основою для імітаційних методів радіоелектронного подавлення.

// Типова схема DRFM складається в основному з таких пунктів:

// - Приймач
// - Аналого-цифровий перетворювач (АЦП)
// - Пам'ять (SRAM/DDR)
// - Блок цифрової обробки
// - Цифро-аналоговий перетворювач (ЦАП)
// - Передавач

// Найчастіше усі фізичні елементи і логіка прийому та передавання
// уже реалізовані всередині SDR, тому основним елементом схеми є блок цифрової обробки,
// який зазвичай
// реалізується на ПЛІС, яка забезпечує детерміновану затримку обробки і паралельність виконання.
// Саме у цьому блоці виконується запис
// сигналу у пам'ять, формування лінії затримки або інші довільні операції над сигналом.


// DRFM is able to conduct following attacks on enemy radars:

// - *Time offset* --- introducing delay to retransmitted signal imitates false distance to target to enemy radar.

// - *Doppler shift* --- introducing frequency offset to imitate false target speed.

// DRFM efficiency is constrained by these:

// - *Bandwidth* defined by ADC/DAC sampling frequency.

// - *Bitwidth* defines signal dynamic range.

// - *Minimal latency (round-trip)* defines minimal achievable latency and is critical to coherent jamming solutions.

// - *DDR Memory depth* defines maximum recorded signal length and means maximum delay of retransmitting.
// Deeper analysis of these properties is conducted in @mesarcik2019drfm.

== The OcuSync target link
// Describe what is publicly known about the OcuSync physical layer (coded OFDM, 20 MHz channels,
// frequency hopping) and give the DroneID-derived parameters as the order-of-magnitude reference,
// flagging that they describe the broadcast, not the video link. State that the exact video-link
// parameters are unknown from the literature and are measured in Chapter 5.

== Research gap and hypotheses
// Draw the gap table (what the literature has, what is missing, what this thesis does) and the
// hypotheses table (H1: the replica beats barrage; H2: the delay, not the added power, causes the
// effect). This subsection is the hinge between the review and the rest of the thesis.

// Draft gap statement moved from the former intro Related Work:
This analysis proves that while a lot of research is being done on jamming OFDM links and abusing its weak spots, vulnerability to complex multipath reflection scenarios introduced by CP is not investigated enough. Although DRFM framework is perfect candidate for creating such difficult conditions for OFDM-based systems, its role in modern attack schemes is quite modest and its efficiency is barely checked in real RF environments with commercial protocols. On the other hand, DRFM is viewed mainly as an instrument to radar deception which it was originally created for.

// TODO: temporary visible citation dump so every relevant bibliography entry renders while the
// chapter is still an outline. Delete this block once each work is cited in the prose.
// (zahnoDynamicProjectPlanning2023 is a template leftover and is intentionally omitted.)
TEMP citations to clean up later:
@adamy2001 @mesarcik2019drfm @pirayesh2022jamming @lichtman2016lte @shahriar2015ofdm
@aref2020cognitive @crockett2023rfsoc @li2017cpjamming @scott2011cpjamming @ucuncu2015ofdm
@clancy2011pilot @lapan2012sync @shahriar2013offtone @bilodeau2014drfm @lichtman2016taxonomy
@wilhelm2011reactive @nguyen2014reactive @schiller2023droneid @zidane2024drone @li2022jamming
@roome1990drfm @sunderlin2017rfnoc @braun2016rfnoc
