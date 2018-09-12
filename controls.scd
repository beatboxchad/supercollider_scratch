Ndef(\ctl_1, {MouseX.kr(0.0001,2,0,0.2)})

Ndef(\ctl_2, {MouseY.kr(440, 1200)});

Ndef(\MouseX, {MouseX.kr(0.0001, 0.004, 1)})

Ndef(\MouseY, {MouseY.kr(0.01, 1.2, 1)})

Ndef(\maus, { MouseX.kr });

Ndef(\pitch, {arg kbus; Tartini.kr(SoundIn.ar(kbus));})

Ndef(\ratio)