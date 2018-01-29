(
~stereo = {
	var input;
	input = \in.ar(0);
	[input, input]

}
)
(
~phasor = {arg freq=0.2;
	var input, effect;
	input=\in.ar(0); //get two channels of input starting (and ending) on bus 0
	effect= AllpassN.ar(input,0.02,SinOsc.kr(freq,0,0.01,0.01)); //max delay of 20msec
	input + effect
}
)

(
~normaldelay = {
	arg speed, feedback;
	var input, delayTime, laggedDelayTime, outDelay, final;

	input = \in.ar(0) * 0.15;
	// lagged delay time - takes 3 seconds to reach new value
	laggedDelayTime = Lag.kr(speed, 0.01);
	// CombC - delay with feedback

	final = CombC.ar(input, 2, laggedDelayTime, MouseY.kr(0.01, 6)) + input;
	final
}

)

(
~gardendelay = {
	arg speed, feedback;
	var input, fBLoopIn, fBLoopOut, processing;
	input = \in.ar(0) * 0.15;
	fBLoopIn = LocalIn.ar(1);
	processing = LeakDC.ar((DelayC.ar(fBLoopIn, 3.5, speed, feedback)));
	processing = PitchShift.ar(processing, 0.2, 1 - (SinOsc.kr(speed*12, 0, 0.03)));
	processing = RHPF.ar(processing,200,0.8);
	fBLoopOut = LocalOut.ar(input + processing);
	input + processing
}

)


~voxOctave = {
	var input, processing, outbus;
	input = SoundIn.ar(1);
	outbus = 1;
	processing = PitchShift.ar(input, 0.5, MouseX.kr(-1, 2));
	Out.ar(outbus, input + processing);}.play
)
