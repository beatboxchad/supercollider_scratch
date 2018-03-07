
Ndef(\sound, { arg freq; SinOsc.ar(freq * [1, 1.2], \phase.ar([0, 0]))  });
Ndef(\ryan, {SoundIn.ar(1)})
Ndef(\scott, {SoundIn.ar(0)});

Ndef(\sound).map(\freq, Ndef(\ctl_2))
Ndef(\sound).fadeTime = 0.2;

Ndef(\scott).play
Ndef(\ryan)
(
Ndef(\gardendelay, ~gardendelay);
Ndef(\gardendelay).map(\speed, Ndef(\MouseX));
Ndef(\gardendelay).map(\feedback, Ndef(\MouseY));

Ndef(\scottdelay, ~gardendelay);
Ndef(\scottdelay).map(\speed, Ndef(\MouseX));
Ndef(\scottdelay).map(\feedback, Ndef(\MouseY));


)
Ndef(\volume, {arg level; \in.ar(0) * level})
Ndef(\volume).map(\level, Ndef(\maus))
Ndef.clear(3);
Ndef(\voice) <>> Ndef(\gardendelay)
Ndef(\) <>> Ndef(\octave) <>> Ndef(\gardendelay)

Ndef(\scottdelay).play
Ndef(\scott) <>> Ndef(\scottdelay);

Ndef(\voice).stop

Ndef(\octave, ~octaver);

Ndef(\octave).set(\ratio, 0.5)


Ndef(\haus, { Pan2.ar(Blip.ar(Ndef.kr(\maus, 2) * 900), SinOsc.kr(Ndef.ar(\maus, 1) * 5)) }).stop;
Ndef(\gardendelay) <<> Ndef(\haus)
Ndef(\gardendelay).play
