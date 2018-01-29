// a SynthDef, creating single-channel grain when instantiated
"/home/chad/SynthDefs-for-Patterns/all.scd".loadPath
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
)
(
SynthDef(\grain, { |out=0, freq=300, amp=0.3|
    OffsetOut.ar(out, Pulse.ar(freq) * EnvGen.kr(Env.perc, doneAction: 2) * amp)
}).add;
)

(
// number of channels
~numChans = 5;

// values in a Pattern may be set in various ways
// here we use control buses, except for \dur which
// doesn't accept a control bus in parallel playing streams
// therefore we use PatternProxies
~durs = ~numChans.collect({ |i| PatternProxy(0.5 + (i/10)) });

// other parameters could as well be controlled in PatternProxies,
// yet, control buses are convenient either
~freqs = Bus.control(s, ~numChans);
~freqs.setn(Array.geom(~numChans, 320, 1.1));
~freqs.setn([880, 550, 440, 440, 500, 40]);
~amps = Bus.control(s, ~numChans, 150, 8);
~amps.setn(0.1!~numChans);

(
// the Pattern: a Ppar holding one Pbind for each channel,
// all wrapped in a Pdef
    Ppar({ |i|
        Pbind(
			\instrument, \grain,
            // we only set a single channel
            \dur, ~durs[i],
            \freq, ~freqs.subBus(i).asMap,
            \amp, ~amps.subBus(i).asMap,
            // the Pattern will play to a yet unknown private bus
            // we only want to make sure the offset is right
            \channelOffset, i,
        )
    }!~numChans)
)

(
// initialize an Ndef that will hold the Pdef as its source
// make sure the Ndef gets initialized to the right number of channels by calling 'mold'
Ndef(\ppar).mold(~numChans, \audio, \elastic);
Ndef(\ppar)[0] = Pdef(\ppar);

// mix the 5 channel audio coming from Ndef(\ppar) down to stereo
// Splay will spread the channels over the stereo panorama
// possibly use headphones to clearly identify the effect
Ndef(\stereo, { Splay.ar(\in.ar(0!~numChans)) });

// concatenate the Ndefs, so Ndef(\ppar)'s out will feed into Ndef(\stereo)'s in
Ndef(\stereo) <<> Ndef(\ppar);
Ndef(\stereo).play;

// change durations
~durs.do({ |pp, i| pp.source = Pseq([1.25, 0.2, 0.1, 0.2, 0.5, 0.25], inf) });
~durs.do({ |pp, i| pp.source = 0.55 + (i/10) * 2 });
~durs.do({ |pp| pp.source.postcs });


// frequencies
~freqs.setn(Array.geom(~numChans, 600, 1.5));
~freqs.setn(Array.geom(~numChans, 140, 1.5));

Array.geom(~numChans, 300, 1.5).postln
)
// add a filter Ndef
(
Ndef(\filter, {
    HPF.ar(
        \in.ar(0!~numChans),
        SinOsc.ar({|i| 2 + i}!~numChans) + 1 * \multFreq.kr(Array.geom(~numChans, 400, 2))
    )
}).mold(~numChans, \audio, \elastic);
)

// set a fadeTime for smooth transitions and add the filter to the chain
#[ppar, stereo, filter].do({ |k| Ndef(k).fadeTime_(3) });
Ndef(\stereo) <<> Ndef(\filter) <<> Ndef(\ppar);

// set filter param, considering fadeTime
Ndef(\filter).xset(\multFreq, Array.rand(~numChans, 20, 6600));

Ndef.clear;
Pdef.clear;


r = Routine({
    var delta;
	var freq;
    loop {
		freq = Scale.major.cents.choose + 100;
		freq.postln;
        delta = rrand(1, 4) * 0.5;
        Synth(\singrain, [freq: freq, amp: rrand(0.1, 0.5), decay: delta * 0.8]);
		~freqs.setn(Array.geom(~numChans, freq/rrand(0.5, 2), 1.5));
        delta.yield;
    }
});

)
CmdPeriod.run:
r.play
s.boot


(
SynthDef(\kik, { |out, preamp = 1, amp = 1|
    var    freq = EnvGen.kr(Env([400, 66], [0.08], -3)),
        sig = SinOsc.ar(freq, 0.5pi, preamp).distort * amp
            * EnvGen.kr(Env([0, 1, 0.8, 0], [0.01, 0.1, 0.2]), doneAction: 2);
    Out.ar(out, sig ! 2);
}).add;
)

Ndef(\k, Pbind(\instrument, \kik, \delta, 2, \preamp, 4.5, \amp, 0.32))
Ndef(\k) <<>.in Ndef(\guitardelay)
s.reboot
