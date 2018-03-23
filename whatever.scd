Ndef(\sound, { arg freq; SinOsc.ar(freq * [1, 1.2], \phase.ar([0, 0]))  });

Ndef(\lineOh, {SoundIn.ar(0)});
Ndef(\lineOne, {SoundIn.ar(1)})

Ndef(\sound).map(\freq, Ndef(\ctl_2))
Ndef(\sound).fadeTime = 0.2;

Ndef(\lineOh).stop
Ndef(\lineOne)
(
Ndef(\gardendelay, ~gardendelay);
Ndef(\gardendelay).map(\speed, Ndef(\MouseX));
Ndef(\gardendelay).map(\feedback, Ndef(\MouseY));

Ndef(\lineOhdelay, ~infHoldVerb);
Ndef(\lineOhdelay).map(\speed, Ndef(\MouseX));
Ndef(\lineOhdelay).map(\feedback, Ndef(\MouseY));

)
Ndef(\volume, {arg level; \in.ar(0) * level})
Ndef(\volume).map(\level, Ndef(\maus))
Ndef.clear(3);
Ndef(\voice) <>> Ndef(\gardendelay)
Ndef(\lineOh) <>> Ndef(\octaver) <>> Ndef(\gardendelay)

Ndef(\lineOhdelay).play
Ndef(\lineOhdelay).stop
Ndef(\lineOh) <>> Ndef(\goctave)
Ndef(\goctave).play
Ndef(\lineOne) <>> Ndef(\octave) <>> Ndef(\gardendelay) <>> Ndef(\verb)

Ndef(\goctave, ~octaver)
Ndef(\goctave).set(\ratio, 0.5)
Ndef(\gardendelay).play
Ndef(\verb).play
Ndef(\ratio, ~ratio)
Ndef(\verb).map(\feedback, Ndef(\MouseY))

Ndef(\sine440, {SinOsc.ar(440)})
Ndef(\ratio).set(\control, Ndef(\sine440), \sig, Ndef(\lineOh))
Ndef(\ratio).clear
Ndef(\octave).map(\ratio, Ndef(\ratio))
Ndef(\octave, ~octaver);
Ndef(\octave).play
Ndef(\bork, {SinOsc.kr(440, 0, 2.4)})
Ndef(\verb, ~infHoldVerb)
Ndef(\octave).set(\ratio, 0.5)
Ndef(\octave).map(\ratio, Ndef(\bork));
Ndef(\haus, { Pan2.ar(Blip.ar(Ndef.kr(\maus, 2) * 900), SinOsc.kr(Ndef.ar(\maus, 1) * 5)) }).stop;
Ndef(\lineOhdelay) <<> Ndef(\gardendelay) <<> Ndef(\lineOne)
Ndef(\gardendelay).play
