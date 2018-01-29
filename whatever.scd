({
        var input, delayTime, laggedDelayTime, outDelay, final;
        // input from sound card
        input = SoundIn.ar(0);
        delayTime = MouseX.kr();
        // lagged delay time - takes 3 seconds to reach new value
        laggedDelayTime = Lag.kr(delayTime, 3);
        // CombC - delay with feedback
	// below we declare our variables with 'var'
	final = CombC.ar(input, 2, laggedDelayTime, MouseY.kr(0.01, 6)) + input;
	[final, final]


}.play;
)
(
~gardendelay = {
	arg speed;
	var input, fBLoopIn, fBLoopOut, processing;
	// input is our sound source, a little noise -- note the lowered amplitude// of 0.15
	input = \in1.ar([0,0]) * 0.15;
	fBLoopIn = LocalIn.ar(2);
	processing = LeakDC.ar((DelayC.ar(fBLoopIn, 3.5, speed, MouseY.kr(0, 1.1))));
	processing = PitchShift.ar(processing, 0.2, 1 - (SinOsc.kr(speed*4, 0, 0.03)));
	processing = RHPF.ar(processing,200,0.8);
	// square off the wave form (distortion)
    processing = processing.clip();
	// fBLoopOut is our feedback loop output point
	fBLoopOut = LocalOut.ar(input + processing);
	// Out routes the audio to the speakers. the square brackets send the output to both left
	// and right channels.
	Out.ar([0,1], input + processing);}

)

// delay speed
Ndef(\ctl_1, {MouseX.kr(0.0001,2,0,0.2)};)
(
Ndef(\ctl_1, {SinOsc.kr(7).exprange(0.0001, 2)});
Ndef(\ctl_2, {SinOsc.kr(MouseX.kr(1, 150)).exprange(300, 1000)});
)
Ndef(\sound, { arg freq; SinOsc.ar(freq * [1, 1.2], \phase.ar([0, 0]))  });
Ndef(\sound).map(\freq, Ndef(\ctl_2))
Ndef(\sound).fadeTime = 0.2;


(
Ndef(\gardendelay, ~gardendelay);
Ndef(\gardendelay).map(\speed, Ndef(\ctl_1));

)

Ndef.clear(3);
Ndef(\gardendelay) <<>.in1 Ndef(\sound)

s.reboot
(
~voxbus = Bus.new()
~voxOctave = {
	var input, processing, outbus;
	input = SoundIn.ar(1);
	processing = PitchShift.ar(input, 0.2, MouseX.kr(-1, 1));
	Out.ar(outbus, input + processing);}.play

)
s.quit

{SinOsc.kr(12, 0, 0.03)}.scope()
1000.free()
1002.free()