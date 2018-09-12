(
p.clock.tempo = 0.2;
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,Pdef(\kd),\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][1],\dur,Pdef(\snd),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][1],\dur,Pdef(\hd),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pdef(\td),\amp,1);
~h.play;
~sn.play;
)

Ndef(\decim).play([0,1])
~k <>> Ndef(\gardendelay).play([0,1])
Ndef(\gardendelay).set(\speed, 0.01)
Ndef(\gardendelay).set(\feedback, 0.99)
Ndef(\gardendelay).play

~sn <>> Ndef(\decim)
~k <>> Ndef(\decim)
Ndef(\decim).set(\rate, 1000)
Ndef(\decim).play([0,1])

~t.play
~t[10] = \filter -> {|in| Decimator.ar(in)}
Pdef(\kd, Pbjorklund2(9,26)/4)
Pdef(\snd, Pbjorklund2(14,25)/2)
Pdef(\hd, Pbjorklund2(4,27)/4)
Pdef(\td, Pbjorklund2(8,28)/4)
Pset(~k, \dur, 1)
Pset(\rando, k, 4)

s.quit