// Example
(
Ndef(\hihats, Pbind(
	\instrument, "hihat",
	\dur, Pseq([Rest(1/4), 1/4], inf),
	\att, 0.01,
	\rel, 0.1,
	\ffreq, 11000,
	\pan, 0,
	\amp, 0.3
).play;


Pbind(
	\instrument, "kick",
	\dur, 1/2,
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 1,
);

~leads1 = Pbind(
    \instrument, "sawSynth",
    \midinote, Pseq([
        [50, 53, 55, 57],
        [53, 56, 58, 60],
		Prand([
			[56, 59, 61, 63],
            [49, 52, 54, 56],
		], 1)
		],
        inf
    ),
    \dur, Prand([1, 3, 4, 4.5], inf),
	\att, 0.1,
	\rel, Pkey(\dur) + 1,
	\hifreq, 5000,
    \amp, 0.2
);

~leads = Pbind(
	\instrument, "sawSynth",
	\midinote, Pseq([36, 32, 32, 37], inf),
	\dur, Pseq([1/4, 1/4, 1/2, Rest(3), 1/4], inf),
	\ctranspose, [0, -12],
	\att, 0.01,
	\rel, 0.2,
	\amp, 0.4,
	\lofreq, 100,
	\hifreq, 1000
);

(
~snare = Pbind(
	\instrument, "snare",
	\dur, Pslide([0.15, 0.15, 0.30, 0.15, 0.25], 16),
	\att, 0.01,
	\rel, Pseq([0.1, 0.05, 0.02, 0.08, 0.08], inf),
	\sinfreq, 1,
	\ffreq, Pseq([2000, 4000, 2200, 2800, 440], inf),
	\amp, 0.25
);



)

~snare.play

~snare.free

e = Env.linen(1, 1, 1);
e.at(2);    // == 1
e.at(2.5);    // == 0.5

// print envelope values
r = fork {
    var stream = e.asStream;
    12.do({
        stream.next.postln;
        0.25.wait;
    });
};
(
// Use an envelope to pan notes from left to right and back
p = Pbind(
    \degree, Pwhite(-4, 11, 32),
    \pan, Env(#[-1, 1, -1], #[2, 2], \sin),
    \dur, 0.125
).play;
)

(
p = Pspawner({ |sp|    // sp = the Spawner object
    loop {
            // run a new pattern in parallel
            // the pattern is finite
            // after a few events, it stops and the Pspawner forgets about it
        sp.par(Pbind(
            \degree, Pseries(rrand(-5, 7), #[-1, 1].choose, rrand(4, 7)),
            \pan, rrand(-1.0, 1.0),
            \dur, rrand(0.1, 0.3)    // duration is chosen once for each pattern
        ));
            // tell the Spawner to wait a bit before the next pattern goes
            // DO NOT use numBeats.wait for this!
            // Everything must go through the Spawner
        sp.wait(rrand(1, 4) * 0.25);
    }
}).play;
)

( 'degree': 0, 'dur': 1.5 ).play;

// Scale segments, in the sequence: up, up, down (repeat)
(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, 0.125
).play;
)
p.stop
(
p = Pbind(
	\instrument, "sawSynth",
	\att, 0.01,
	\rel, 0.2,
    \degree, Pslide((-6, -4 .. 12), 64, 3, 1, 0),
    \dur, Pslide(#[0.15, 0.1, 0.25, 0.2, 0.25, 0.125], inf),
    \sustain, 0.15
).play;
)
p.play

Bus([0,1]).scope
(
TempoClock.default.tempo = 132/60;
Ndef(\phat_basslines, Pseq([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.25], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pbind(\instrument, \bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )

], inf)
)
)



Ndef(\guitardelay).mold(2, \audio, \elastic)
Ndef(\stereo).stop
Ndef(\phat_basslines).mold(2, \audio, \elastic)
CmdPerio
Ndef(\guitardelay).play
Ndef(\guitardelay) <<>.in Ndef(\phat_basslines)
Ndef(\phat_basslines).stop
p.play
Bus([0,1]).scope
