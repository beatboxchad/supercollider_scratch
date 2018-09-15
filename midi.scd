(
// rate controls
c = MKtl(\akai, "*lpd8");
[\kick, \snare, \hat, \tom].do {|drum, i|

	c.elAt(\kn0, i).action = {
		arg el;
		var length = g[\emcontrols][drum][\length];

		g[\emcontrols][drum][\hits] = el.value.linexp(
			0, 1, 1, length).round;

		g[\emcontrols][\setSource].(drum);
	};

	c.elAt(\kn0, i + 4).action = {
		arg el;
		g[\emcontrols][drum][\length] = el.value.linexp(0, 1, 1, 50);
		g[\emcontrols][\setSource].(drum);

	};
};

// play control and triggers

[~k, ~sn, ~h, ~t].do {|drum, i|
	i.postln
	// reassign [0] to the pbindef for trigger. Figure out some play-pause state deal for the other.

	// here's the old example:

/*	c.elAt(\pad, 0).action = {arg el;
		(el.type == 'padUp').if {
			~kg.set(\a, 4);
			Pdefn(\k).source = { Pbjorklund2(~emcontrols[\kick][\length].get(\a), ~kh.get(\a))/~kg.get(\a)}

		}*/
	};
)

(
c = MKtl(\akai, "*lpd8");



// delay ctl

c.elAt(\kn1, 0).action = {
    arg el;
	~k.set(\speed, el.value);

};


c.elAt(\kn1, 1).action = {
    arg el;
	~k.set(\feedback, el.value + 0.5);

};


c.elAt(\kn1, 2).action = {
    arg el;
	~k.set(\pitchspeed, el.value * 10);

};


c.elAt(\kn1, 3).action = {
    arg el;
	~k.set(\pitchdepth, el.value - 0.5);

};
)