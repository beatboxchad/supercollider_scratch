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
~delay = {
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
	input = \in.ar(1);
	fBLoopIn = LocalIn.ar(1);
	processing = LeakDC.ar((DelayC.ar(fBLoopIn, 3.5, speed, feedback)));
	processing = PitchShift.ar(processing, 0.2, 1 - (SinOsc.kr(speed*4, 0, 0.03)));
	processing = RHPF.ar(processing,200,0.8);
	fBLoopOut = LocalOut.ar(input + processing);
	processing + input
};

)
Ndef(\out, {})
Ndef(\out).play([0,1])
Ndef(\out).clear
Ndef(\delay, ~gardendelay)
s.stopRecording
Ndef(\delay).play(0, 2)
Ndef(\delay).stop

Ndef(\delay).clear
(
~octaver = {// TODO make this polyphonic
	arg ratio = -1;
	var input, processing;
	input = \in.ar();
	processing = PitchShift.ar(input, 0.25, ratio);
	input + processing;
}
)

(
~harmFollow = {
	arg kbus;
	var input, ksig, ratio, processing;
	input = \in.ar();
	ksig = SoundIn.ar(kbus);
	ratio = Tartini.kr(ksig) - Tartini.kr(input) % 1; // FIXME coerce this to positive
	processing = PitchShift.ar(input, 0.25, ratio);
	input + processing;
}
)
(
~ratio = {
	arg control, sig;
	var cpitch, spitch, ratio;
	cpitch = Tartini.kr(control);
	spitch = Tartini.kr(sig);
	ratio = spitch - cpitch % 1;
	ratio;
}
)


(
~infHoldVerb = {
	arg feedback = 1;
	var input, processing;
	input = \in.ar(0);
	processing = LocalIn.ar(2)+input.dup;
	15.do{processing = AllpassN.ar(processing, 0.06, Rand(0.001, 0.04), 3)};
	LocalOut.ar(input + processing * feedback);
	input + processing

}
)
