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
}

// play control and triggers

[~k, ~sn, ~h, ~t].do {|drum, i|
	// reassign [0] to the pbindef for trigger. Figure out some play-pause state deal for the other.
)
(
c = MKtl(\akai, "*lpd8");



// glitchers

c.elAt(\pad, 0).action = {arg el;
	(el.type == 'padUp').if {
		~kg.set(\a, 4);
		Pdefn(\k).source = { Pbjorklund2(~emcontrols[\kick][\length].get(\a), ~kh.get(\a))/~kg.get(\a)}

	};
	(el.type == 'pad').if {
		~kg.set(\a, 4 * el.value * 100);
		Pdefn(\k).source =  {Pbjorklund2(~emcontrols[\kick][\length].get(\a), ~kh.get(\a))/~kg.get(\a)}

	}

};

c.elAt(\pad, 1).action = {arg el;
	(el.type == 'padUp').if {
		~sg.set(\a, 4);
		Pdefn(\s).source = { Pbjorklund2(~sl.get(\a), ~sh.get(\a))/~sg.get(\a)};

	};
	(el.type == 'pad').if {
		~sg.set(\a, 4 * el.value * 100);
		Pdefn(\s).source = {Pbjorklund2(~sl.get(\a), ~sh.get(\a))/~sg.get(\a)};
	}

};
c.elAt(\pad, 2).action = {arg el;
	(el.type == 'padUp').if {
		~hg.set(\a, 4);
		Pdefn(\h).source = { Pbjorklund2(~hl.get(\a), ~hh.get(\a))/~hg.get(\a)};
	};
	(el.type == 'pad').if {
		~hg.set(\a, 4 * el.value * 100);
		Pdefn(\h).source = { Pbjorklund2(~hl.get(\a), ~hh.get(\a))/~hg.get(\a)};
	};

};
c.elAt(\pad, 3).action = {arg el;
	(el.type == 'padUp').if {
		~tg.set(\a, 4);
		Pdefn(\t, Pbjorklund2(~tl.get(\a), ~th.get(\a))/~tg.get(\a));
	};
	(el.type == 'pad').if {
		~tg.set(\a, 4 * el.value * 100);
		Pdefn(\t).source = { Pbjorklund2(~tl.get(\a), ~th.get(\a))/~tg.get(\a)};
	}

};


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