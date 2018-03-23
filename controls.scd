Ndef(\ctl_1, {MouseX.kr(0.0001,2,0,0.2)};)
Ndef(\ctl_1, {SinOsc.kr(7).exprange(0.0001, 2)});
Ndef(\ctl_2, {MouseY.kr(440, 1200)});

Ndef(\MouseX, {MouseX.kr(0.01, 3)})

Ndef(\MouseY, {MouseY.kr(0.00001, 1.01)})

Ndef(\maus, { MouseX.kr });

Ndef(\pitch, {arg kbus; Tartini.kr(SoundIn.ar(kbus));})

Ndef(\ratio)