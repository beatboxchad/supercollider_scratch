(
SynthDef(\coreyDesyp, {|gate = 1, freq = 440, att = 0.001, dec = 0.001, sus = 0.75, rel = 0.125, lfofreq = 3, lopfreq = 800, rq = 0.5,
        detune1 = 12, detune2 = 8, amp = 1, pan = 0, out = 0|
        var env = EnvGen.ar(Env.adsr(att, dec, sus, rel, amp), gate, doneAction:2);
        var nvoices1 = 5, nvoices2 = 7;

        var osc1 = {
                var m = 2**(detune1/1200).rand2;
                var lfo = SinOsc.ar(lfofreq.rand).range(0,1);
                DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
        }.dup(nvoices1);

        var osc2 = {
                var m = 2**(detune2/1200).rand2;
                var lfo = SinOsc.ar(lfofreq.rand).range(0,1);
                DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
        }.dup(nvoices2);

        var output = BLowPass4.ar(osc1, lopfreq, rq) + osc2 / 4;
        output = Pan2.ar(output*env, pan);
        Out.ar(out, output);
}).add;


SynthDef(\grain, { |out=0, freq=300, amp=0.3|
    OffsetOut.ar(out, Pulse.ar(freq) * EnvGen.kr(Env.perc, doneAction: 2) * amp)
}).add;
)

(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;


SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
    Out.ar(0, sig ! 2);    // sig ! 2 is the same as [sig, sig]
}).add;

// Basic drum kit

SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var env, snd;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = WhiteNoise.ar;
	snd = HPF.ar(in: snd, freq: ffreq, mul: env);
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

SynthDef("snare", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var env, snd1, snd2, sum;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq,
		mul: env
	);
	snd2 = SinOsc.ar(freq: sinfreq, mul: env);
	sum = snd1 + snd2;
	Out.ar(out, Pan2.ar(sum, pan));
}).add;

SynthDef("kick", {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var env, snd, ramp;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).add;

// Basic saw synth for chords and bass
SynthDef("sawSynth", { arg freq = 440, amp = 0.1, att = 0.1, rel = 2, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq * [0.99, 1, 1.001, 1.008], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
}).add;
)
