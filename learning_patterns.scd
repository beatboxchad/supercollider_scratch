(
p.clock.tempo = 2.2;
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,Pdef(\kd),\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][1],\dur,Pdef(\snd),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][1],\dur,Pdef(\hd),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pdef(\td),\amp,1);
~t.play
)
~a =  { |freq = 440, dt=0.1, rate=2| Ringz.ar(Impulse.ar(rate * [1, 1.2]), freq, dt)*0.1 };
(
~a[1] = \xset -> Pbind(
    \dur, Prand([1, 0.5], inf),
    \freq, Pwhite(200.0, 1000, inf).round(30),
    \rate, Pstutter(4, Prand([1, 3, 6, 10], inf)),
    \dt, Pwhite(0.01, 0.1, inf) + 1
);
)
~a.fadeTime = 2
~a = { |freq = 440, dt=0.1, rate=2| Ringz.ar(Dust.ar(rate * 10.dup), freq, dt)*0.1 };

~a[10] = \filter -> {~delay}


~delay.play([0,1])
~a.play

~delay.set(\feedback, 1)

Ndef(\decim).play([0,1])
~k<>> Ndef(\gardendelay).play([0,1])
Ndef(\gardendelay).set(\speed, 0.01)
Ndef(\gardendelay).set(\feedback, 1.5)
Ndef(\gardendelay).set(\pitchspeed, 240)
Ndef(\gardendelay).set(\pitchdepth, 08.1)
Ndef(\gardendelay).play
~sn.stop
~sn <>> Ndef(\decim)
~k <>> Ndef(\decim)
Ndef(\decim).set(\rate, 4000)
Ndef(\decim).play([0,1])
Ndef(\decim).stop
~t.play
~t[10] = \filter -> {|in| Decimator.ar(in, 3000)}
Pdef(\kd, Pbjorklund2(9,26)/4)
Pdef(\snd, Pbjorklund2(14,25)/2)
Pdef(\hd, Pbjorklund2(4,27)/4)
Pdef(\td, Pbjorklund2(8,28)/4)
Pset(~k, \dur, 1)
Pset(\rando, k, 4)

e[\vibrato]= {
                arg rate = 0.5, depth = 0.03;
                var input, control, out;

                input   = \in.ar(0);
                control = SinOsc.kr(freq: rate, mul: depth);
                out     = PitchShift.ar(input, windowSize: 0.05, pitchRatio: 1+control);
                input + out;
            }
~vibrato.controlKeys
~a.play([0,1])
~a.set(~a.controlNames[0], 4)
~vibrato1 = ~vibrato.copy()
~vibrato.play([0, 1])
~mic.stop
~mic <>> ~vibrato
e = Dictionary()

~mic[10] = \filter -> e[\vibrato]