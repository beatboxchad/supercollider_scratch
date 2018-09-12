
Ndef(\acel_x, {|accel|Lag.kr(accel)})
Ndef(\acel_y, {|accel|Lag.kr(accel)})
Ndef(\acel_x, {|accel|Lag.kr((accel).linlin(-20, 20, -1, 1), 02)})
s.boot
Ndef(\pos_x, {|pos| Lag.kr(pos)})
Ndef(\pos_y, {|pos| Lag.kr(pos)})
Ndef(\pos_z, {|pos| Lag.kr(pos)})

(a = OSCFunc(
	{ arg msg, time, addr, recvPort;

		Ndef(\pos_x).set(\pos, msg[2]);
	if (msg[1] == 'p') {
		Ndef(\pos_y).set(\pos, msg[3]);
		Ndef(\pos_z).set(\pos, msg[4]);
	};
	if (msg[1] == 'a') {
		Ndef(\acel_x).set(\accel, msg[2]);
		Ndef(\acel_y).set(\accel, msg[3]);
		Ndef(\acel_z).set(\accel, msg[4]);
	};
		Ndef(\acel_z).get(\accel).postln;


	}, '/accel');

	)
a.free
(
Ndef(\testsine, { arg freq;
	// freq = 440 ;
	SinOsc.ar(freq, mul:0.25);
}    nr
)
)
s.boot
Ndef(\pos_x).set(\pos, -4.9994)
Ndef(\testsine).set(\freq, 440)
Ndef(\acel_z).set(\accel, 1)

Ndef(\vibrato).map(\depth, Ndef(\acel_y))
Ndef(\octave, ~octaver)
Ndef(\octave).map(\ratio, Ndef(\acel_z))
Ndef(\guitar).play
Ndef(\trum).play
<>> Ndef(\octave).play(0)
Ndef(\vibrato).stop
s.reboot

{ Integrator.ar(LFPulse.ar(1500 / 4, 0.2, 0.1), MouseX.kr(0.01, 0.999, 1)) }.scope