(
SynthDef(\phaser, { arg out=0, in=0;

    var input,dsig, mixed;
    input = SoundIn.ar(in, 1);

    dsig = AllpassL.ar(input, 2, SinOsc.ar(0.2, 0, 0.005, 0.005), 0);
    mixed = input + dsig;
    Out.ar([out, out+1], mixed);
}).load(s);
)

a = Synth(\phaser, addAction:\addToTail)


(
SynthDef(\dd6, {
	arg out=0, in=0;

    var input,dsig, mixed, dtime, feedback;
    input = SoundIn.ar(in, 1);

	dtime = MouseX.kr(0.01, 4);
	feedback = MouseY.kr(0, dtime * 32);
    dsig = AllpassC.ar(input, dtime * 8, dtime, feedback);
    mixed = input + dsig;
    Out.ar([out, out+1], mixed);
}).load(s);
)

b = Synth(\dd6, addAction:\addToTail)