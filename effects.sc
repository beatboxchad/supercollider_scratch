e = Dictionary();

e[\phasor] = {
    arg input, phase_freq=0.2;
    var effect;
    effect = AllpassN.ar(
        input,
        0.02,
        SinOsc.kr(phase_freq,0,0.01,0.01)); //max delay of 20msec
    input + effect
};


e[\delay] = {
    arg input, dspeed, dfeedback;
    var delayTime, laggedDelayTime, outDelay, final;

    laggedDelayTime = Lag.kr(dspeed, 0.01);
    // CombC - delay with feedback

    final = CombC.ar(input, 2, laggedDelayTime, dfeedback) + input;
    final
};

e[\gardendelay] = {
    arg input, speed=0.05, feedback=0.9, pitchspeed=4, pitchdepth=0.03;
    var fBLoopIn, fBLoopOut, processing;
    fBLoopIn = LocalIn.ar(2);
    processing = LeakDC.ar((DelayC.ar(fBLoopIn, 3.5, speed, feedback)));
    processing = PitchShift.ar(processing, 0.2, 1 - (SinOsc.kr(pitchspeed, 0, pitchdepth)));
    //	processing = RHPF.ar(processing,200,0.8);
    fBLoopOut = LocalOut.ar(input + processing);
    input + processing
};

e[\resonator] = {
    arg input, freq = 440, feedback=0.995;
    var in, sound;

    in = LocalIn.ar(input);
    sound = DelayC.ar(input + (in * feedback), 1, freq.reciprocal - ControlRate.ir.reciprocal);
    LocalOut.ar(sound); // for feedback
    sound
};

e[\decim] = {
    arg input, rate=1000, bits=27000;
    var out;

    out = Decimator.ar(input, rate, bits);
    out
};


e[\octaver] = {
    // TODO make this polyphonic, take an array of ratios -> array of pitchshifts -> sum out
    arg ratio = 0.5;
    var input, wet;
    input = \in.ar();
    wet = PitchShift.ar(input, 0.25, 1 +ratio);
    input + wet;
};


e[\harmFollow] = {
    arg kbus;
    var input, ksig, ratio, processing;
    input = \in.ar();
    ksig = SoundIn.ar(kbus);
    ratio = Tartini.kr(ksig) - Tartini.kr(input) % 1; // FIXME coerce this to positive
    processing = PitchShift.ar(input, 0.25, ratio);
    input + processing;
};

e[\ratio] = {
    arg control, sig;
    var cpitch, spitch, ratio;
    cpitch = Tartini.kr(control);
    spitch = Tartini.kr(sig);
    ratio = spitch - cpitch % 1;
    ratio;
};



e[\infHoldVerb] = {
    arg feedback = 1;
    var input, processing;
    input = \in.ar(0);
    processing = LocalIn.ar(2)+input.dup;
    15.do{processing = AllpassN.ar(processing, 0.06, Rand(0.001, 0.04), 3)};
    LocalOut.ar(input + processing * feedback);
    input + processing

};


e[\vi_brat_o] = {
    arg rate = 0.5, depth = 0.03;
    var input, control, out;

    input   = \in.ar(0);
    control = SinOsc.kr(freq: rate, mul: depth);
    out     = PitchShift.ar(input, windowSize: 0.05, pitchRatio: 1+control);
    input + out;
};


