#import "/local-lib/template-thesis.typ": *
#import "/metadata.typ": *
#pagebreak()
= #i18n("analysis-title", lang:option.lang) <sec:analysis>

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

== OFDM

#figure(
  image("/resources/img/ofdm_frame.png", width: 15cm),
  caption: [OFDM frame structure: three sequential OFDM symbols with $K$
     subcarriers, each starting with CP
     (source: @ucuncu2015ofdm)]
)

// Orthogonal Frequency Division Multiplexing (OFDM) is one of the main building blocks for modern wireless communication systems PHY-layer --- Wi-Fi, LTE, 5G, digital TV and whats more important in the context of this thesis, communication systems for UAV, also specifically, Ocusync для Mavic. Принцип OFDM полягає в поділі широкосмугового каналу на велику кількість ортогональних вузькосмугових піднесучих, кожна з яких модулюється незалежно. Такий підхід забезпечує високу спектральну ефективність та стійкість до частотно-селективного завмирання (frequency selective fading). Також у каналах зв'язку присутня проблема викликана багатопроменевим поширенням (multipath propagation), цей ефект спричиняє те, що у канал приймача приходять кілька затриманих у часі копій сигналу і призводить до ISI. Одним із ключовиx елементів, що забезпечує стійкість OFDM до ISI є циклічний префікс (CP). CP формується копіюванням з кінця деякої частини OFDM-символу та додаванням її на початок як захисного інтервалу. Довжина CP обирається більшою за максимальну затримку багатопроменевого поширення в каналі. Якщо ця умова дотримана, то лінійна згортка сигналу з імпульсною характеристикою каналу перетворюється на циклічну, що зберігає ортогональність піднесучих та дозволяє приймачу відновити символи. Таким чином, CP усуває ISI знижуючи пропускну здатність. Саме ця роль CP спричиняє вразливість OFDM-систем, яку буде розглянуто далі. 

== DRFM

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


== Repeater Attack efficiency in OFDM jamming

#figure(
  image("/resources/img/ber_wifi.png", width: 12cm),
  caption: [BER vs SNR for Wi-Fi OFDM signal  for different values of delay $Delta$ (source: @li2017cpjamming)]
)
 
// Згідно з першим розділом, де описується функція CP у схемі OFDM, умовою коректного прийому сигналу без ISI є вибір довжини CP, яка буде більшою за затримки усіх копій сигналу на приймачі спричинених багатопроменевим поширенням. Якщо ця умова порушена, лінійна згортка сигналу з імпульсною характеристикою каналу перестає бути циклічною і BER починає погіршуватись, що зображено на фото вище. Саме цю вразливість можна використати застосувавши DRFM, вибравши таку затримку для відтворення сигналу, що довжини CP буде недостатньо. Дослідження показують, що атака на CP використовує потужність передавача 
// ефективніше порівняно з класичним шумовим подавленням @pirayesh2022jamming, до того ж, залишається менш помітним для приймача, оскільки сприймається ним як звичайне багатопроменеве поширення @li2017cpjamming.