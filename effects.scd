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
	input = \in.ar(0) * 0.25;
	fBLoopIn = LocalIn.ar(1);
	processing = LeakDC.ar((DelayC.ar(fBLoopIn, 3.5, speed, feedback)));
	processing = PitchShift.ar(processing, 0.2, 1 - (SinOsc.kr(speed*4, 0, 0.03)));
	processing = RHPF.ar(processing,200,0.8);
	fBLoopOut = LocalOut.ar(input + processing);
	input + processing
};

)

(
~octaver = {// TODO make this polyphonic
	arg ratio = -1;
	var input, processing;
	input = \in.ar();
	processing = PitchShift.ar(input, 0.5, ratio) * 1.2;
	input + processing;
}
)
~voxOctave.free

CmdPeriod.run
(
Ndef(\vox, {var input = SinOsc.ar(440);
	input
}
)
)

Ndef(\vox)

Ndef(\delay, ~gardendelay)

Ndef(\delay).play

Ndef(\vox).stop
Ndef(\delay) <<>.in Ndef(\vox)
Ndef(\delay).play

(
	~harmonizer = {
	//(definst harmonize-input
		arg note=60, gate = 1, bus = 1;
		var in, haspitch, pitch, amp, env, ratio, sig;
		in = SoundIn.ar(bus);
        # pitch, haspitch = Tartini.kr(in);
        amp = Amplitude.kr(in);
        env = EnvGen.kr(Env.adsr(0.01, 0.1, 1, 0.3), gate, doneAction: 2);
        ratio = note.midicps / pitch;
        sig = PitchShift.ar(in, pitchRatio: ratio);
		sig * amp * env;
}

)

CmdPeriod.run

//freddie freeloader on trumpetx

s.reboot
MIDIClient.init
MIDIIn.connectAll
~g = NPVoicer(Ndef(\harmonize));     // make an NPVoicer with an Ndef in it
~g.prime(~harmonizer);            // prepare it with the default synthdef

~g.play();                    // play it

~g.releaseAll()
~g.proxy <<>.in Ndef(\delay)
    // start a sound with key 48, with its won set of params
~g.put(48, [\note, 48, \bus, 0, \gate, 0]);

    // a second note at 51
~g.put(51, [\freq, 51.midicps]);

    // release them
~g.release(50);
~g.release(45);
~g.release();
s.latency = nil
// test with MIDI if you have a controller around:
MIDIdef.noteOn(\harmonizerOn, {arg vel, note, chan;  ~g.put(note, [\note, note, \bus, 1, \gate, 1])})
MIDIdef.noteOff(\harmonizerOff, {arg vel, note, chan;  ~g.put(note, [\gate, 0])})
MIDIdef.noteOff(\harmoniz, { arg vel, note, chan; ~g.release(note)});
MIDIdef.noteOn(\test4, {arg vel, note,  chan; note.postln}); // match any noteOn
MIDIdef.noteOff(\test4, {arg vel, note, chan; ("Note Off: " + note).postln})
MIDIdef.freeAll



(
s.latency = nil;
g = NPVoicer(Ndef(\x));
g.prime({ |freq = 400| SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.001, 0.03, 0.4), doneAction:2) }, true);
g.play;


)

Ndef(\room, {SoundIn.ar(0)});

Ndef(\delay, ~gardendelay);


Ndef(\delay).map(\speed, Ndef(\MouseX))
Ndef(\delnay).map(\feedback, Ndef(\MouseY))

Ndef(\room) <<>.in Ndef(\delay)

Ndef(\delay).stop