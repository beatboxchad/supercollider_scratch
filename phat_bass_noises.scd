Pitch.kr

(
SynthDef("pitchFollow1",{
    var in, amp, freq, hasFreq, out;
    in = SoundIn.ar(0);
    amp = Amplitude.kr(in, 0.05, 0.05);
    # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 6);
    //freq = Lag.kr(freq.cpsmidi.round(1).midicps, 0.05);
    out = VarSaw.ar(freq * [0.5,1,2], 0, LFNoise1.kr(0.3,0.1,0.1), amp / 2);
    6.do({
        out = AllpassN.ar(out, 0.040, 0.040.rand, 2)
    });
    Out.ar(0,out)
	Out.ar(1, in)
}).play(s);
)

(
f = {
        ({arg i;
                var j = i * 2.cubed + 1;
                SinOsc.ar(MouseX.kr(20,800) * j, 0, 1/j)
        } ! 20).sum;
};
)

f.play
