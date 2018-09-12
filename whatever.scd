Ndef(\sound, { arg freq; SinOsc.ar(freq * [1, 1.2], \phase.ar([0, 0]))  });
(
Ndef(\gardendelay, ~gardendelay);
Ndef(\gardendelay).map(\speed, Ndef(\MouseX));
Ndef(\gardendelay).map(\feedback, Ndef(\MouseY));

Ndef(\lineOhdelay, ~infHoldVerb);
Ndef(\lineOhdelay).map(\speed, Ndef(\MouseX));
Ndef(\lineOhdelay).map(\feedback, Ndef(\MouseY));

)
(
Ndef(\volume, {arg level; \in.ar(0) * level});
Ndef(\volume).map(\level, Ndef(\maus));

Ndef(\voice) <>> Ndef(\gardendelay);
Ndef(\lineOne) <>> Ndef(\goctave) <>> Ndef(\gardendelay) <>> Ndef(\verb)
Ndef(\gardendelay).play
)
Ndef(\verb, ~infHoldVerb)
Ndef(\verb).map(\feedback, Ndef(\MouseY))
Ndef(\verb).play
Ndef(\lineOhdelay).play
Ndef(\lineOhdelay).stop

Ndef(\lineOh) <>> Ndef(\octave)
Ndef(\decim, ~decim);

Ndef(\octave, ~octaver)
Ndef(\octave).set(\ratio, 0.5)
Ndef(\octave).play
Ndef(\lineOh) <>> Ndef(\octave) <>> Ndef(\decim)
Ndef(\decim).set(\bits, 8)
Ndef(\decim).play
Ndef(\octave).map(\ratio, Ndef(\acel_z));
Ndef(\sine440, {SinOsc.ar(440)})


Ndef(\octave).map(\ratio, Ndef(\ratio))
Ndef(\octave, ~octaver);
Ndef(\octave).play
Ndef(\bork, {SinOsc.kr(440, 0, 2.4)})

Ndef(\octave).set(\ratio, 0.5)
Ndef(\octave).map(\ratio, Ndef(\bork));
Ndef(\haus, { Pan2.ar(Blip.ar(Ndef.kr(\maus, 2) * 900), SinOsc.kr(Ndef.ar(\maus, 1) * 5)) }).stop;
Ndef(\gardendelay) <<> Ndef(\octave) <<> Ndef(\lineOne)
)