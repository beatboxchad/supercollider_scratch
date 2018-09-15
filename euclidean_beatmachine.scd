(



[\kick, \snare, \tom, \hat].do {|pattern|
	Pdefn(pattern).quant = 0.25;
	Pbindef(pattern).quant = 0.25;
};
g = Dictionary();

g[\emcontrols] = ();

g[\emcontrols][\setSource] = {
	arg drum;
	Pdefn(drum).source = {
		Pbjorklund2(
			g[\emcontrols][drum][\hits],
			g[\emcontrols][drum][\length]) /
		g[\emcontrols][drum][\divisor];
	};
};
g[\emcontrols][\trig] = {
	arg drum;
	Pdefn(drum).source = {
		Pbjorklund2(
			g[\emcontrols][drum][\hits],
			g[\emcontrols][drum][\length]) /
		g[\emcontrols][drum][\divisor];
	};
};

Pbindef(\snare)
[\kick, \snare, \hat, \tom].do {|drum, i|
	g[\emcontrols][drum] = (
		hits: 4,
		length: 4,
		divisor: 4
	);

	g[\emcontrols][drum][\setSource].(drum);
};

~k = Pbindef(\kick, \instrument, \bplay,\buf,d["k"][0],\dur, Pdefn(\kick),\amp,0.2);
~k.play
~k.quant = 0.25
~sn.quant = 0.25
~sn[0]  = Pbindef(\snare, \instrument,\bplay,\buf,d["s"][0],\dur,Pdefn(\snare),\amp,0.2);
~h = Pbindef(\hat, \instrument,\bplay,\buf,d["ch"][2],\dur,Pdefn(\hat),\amp,0.3);
~t = Pbindef(\tom, \instrument,\bplay,\buf,d["t"][0],\dur,Pdefn(\tom),\amp,0.2);
~k.play;
~sn.play;
~h.play;
~t.play;
~k[10] = \filter -> {|in| Decimator.ar(in, bits: 4)};
~sn[10] = \filter -> {|in| Decimator.ar(in, bits: 4)};
~t[10] = \filter -> {|in| Decimator.ar(in, bits: 4)};
~h[10] = \filter -> {|in| Decimator.ar(in, bits: 4)};
[~k, ~sn, ~t, ~h].do {|moo| moo[10] = nil}
)

~tl.set(\a, 0)
~th.set(\a, 12)
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
~a = { |freq = 440	, dt=0.1, rate=2| Ringz.ar(Dust.ar(rate * 10.dup), freq, dt)*0.1 };

~a[10] = \filter -> e[\gardendelay]


~a.play

~delay.set(\feedback, 1)

Ndef(\decim).play([0,1])
~t.play
~t[10] = \filter -> {|in| Decimator.ar(in, 3000)}
~dt = Pdef(\dt, Pbjorklund(9,26)/4)
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

~vibrato.play([0, 1])
~mic.stop
~mic <>> ~vibrato
e = Dictionary()

~mic[10] = \filter -> e[\vibrato]

(1..50).collect {|i|
	~guitar[i] =nil
}