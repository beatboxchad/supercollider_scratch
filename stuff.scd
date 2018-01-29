// requires sc3
(
// requires JITLibExtensions quark, if you don't have it, try global syntax
//     Spec.add(\root, [50, 800, \exp]);
// instead

Ndef(\dfm).addSpec(\root, [50, 800, \exp]);
Ndef(\dfm).addSpec(\width, [0, 1, \lin]);
Ndef(\dfm).addSpec(\ffreqIdx, [0.1, 4, \exp]);
Ndef(\dfm).addSpec(\aNoise, [0, 0.1, \lin]);
Ndef(\dfm).addSpec(\aSaw, [0, 1, \lin]);
Ndef(\dfm).addSpec(\fWet, [0, 1, \lin]);
Ndef(\dfm).addSpec(\aPing, [0, 1, \lin]);

Ndef(\dfm, {
	var root = \root.kr(80, 2);
	var lfo1 = LFTri.kr([0.5, 0.501]);
	var filter;


	var src = VarSaw.ar([root,root*1.01], 0,
		\width.kr(0.5, 1),0.1 * \aSaw.kr(1)) + ({PinkNoise.ar(\aNoise.kr(0, 1))}!2) + Splay.ar((LFPulse.ar([3, 5, 7, 11].scramble * 0.1, 0, 0.01, \aPing.kr(0, 1)) * LFCub.ar(16 * root)));


	filter = DFM1.ar(
		src,
		freq: \ffreqIdx.kr(2, 1) * root,
		res:  lfo1.linlin(-1, 1, 0.1, 1.1),
		inputgain: 1,
		type: 0, // SinOsc.kr(10, [0, pi]).range(0,1),
		noiselevel: 0.0003,
		mul: 0.5
	);

	src = SelectX.ar(\fWet.kr(1, 4), [src, filter]);

	src
	// MyRotate2.ar(src, lfo1.first)
});
);

(
Ndef(\verb).addSpec(\damp, [0, 1]);
Ndef(\verb).addSpec(\diff, [0, 1]);
Ndef(\verb).addSpec(\highband, [1000, 10000, \exp]);
Ndef(\verb).addSpec(\highx, [0, 1]);
Ndef(\verb).addSpec(\lowband, [100, 6000, \exp]);
Ndef(\verb).addSpec(\lowx, [0, 1]);
Ndef(\verb).addSpec(\modDepth, [0, 50]);
Ndef(\verb).addSpec(\modFreq, [0, 2]);
Ndef(\verb).addSpec(\midx, [0, 1]);
Ndef(\verb).addSpec(\size, [0.5, 3]);
Ndef(\verb).addSpec(\t60, [0.1, 60, \exp]);
Ndef(\verb).addSpec(\wet, [0, 1]);
Ndef(\verb).addSpec(\shelfslope, [1, 10]);
Ndef(\verb).addSpec(\shelfFreq, \freq);
Ndef(\verb).addSpec(\fb, [0, 1]);
Ndef(\verb).addSpec(\dtime, [0, 2]);

Ndef(\verb, {
    var src, delay, amp;

    src = LeakDC.ar(Ndef(\dfm).ar);
    src = src * \amp.kr(1);
    // var src = Impulse.ar(0.5);

    delay = Greyhole.ar(
        src,
        \dtime.kr(0.1),
        \damp.kr(0.1),
        \size.kr(1),
        \diff.kr(0.707),
        \fb.kr(0.1),
        \modDepth.kr(0.01),
        \modFreq.kr(2)
    );
    delay
})
)

Ndef(\dfm).edit
Ndef(\verb).edit

Ndef(\dfm).xset(\root, 69)