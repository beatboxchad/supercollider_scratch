

(
c = MKtl(\akai, "*lpd8");
// euclidean beat machine mode, why'd I say quadratic?
// hits per cycle
c.elAt(\kn0, 0).action = {
	arg el;
	~kl.set(\a, el.value.linlin(0,1, 1, ~kh.get(\a)).round);
	Pdefn(\k).source = { Pbjorklund2(
		~kl.get(\a),
		~kh.get(\a))/~kg.get(\a)};
};
// cycle size
c.elAt(\kn0, 4).action = {
    arg el;
    ~kh.set(\a, el.deviceValue + 1);
	Pdefn(\k).source={ Pbjorklund2(~kl.get(\a), ~kh.get(\a))/~kg.get(\a)};
};

// and so on
c.elAt(\kn0, 1).action = {
    arg el;
	~sl.set(\a, el.value.linlin(0,1, 1, ~sh.get(\a)).round);
	Pdefn(\s).source = { Pbjorklund2(~sl.get(\a), ~sh.get(\a))/~sg.get(\a)};

};
c.elAt(\kn0, 5).action = {
	arg el;
	~sh.set(\a, el.deviceValue + 1);
	Pdefn(\s).source = { Pbjorklund2(~sl.get(\a), ~sh.get(\a))/~sg.get(\a)};

};

c.elAt(\kn0, 2).action = {
	arg el;
	~hl.set(\a, el.value.linlin(0,1, 1, ~hh.get(\a)).round);
	Pdefn(\h).source = {Pbjorklund2(~hl.get(\a), ~hh.get(\a))/~hg.get(\a)};


};

c.elAt(\kn0, 6).action = {
	arg el;
	~hh.set(\a, el.deviceValue + 1);
	Pdefn(\h).source = { Pbjorklund2(~hl.get(\a), ~hh.get(\a))/~hg.get(\a)};

};

c.elAt(\kn0, 3).action = {
	arg el;
	~tl.set(\a, el.value.linlin(0,1, 1, ~th.get(\a)).round);
	Pdefn(\t).source = { Pbjorklund2(~tl.get(\a), ~th.get(\a))/~tg.get(\a)};

};
c.elAt(\kn0, 7).action = {
	arg el;
	~th.set(\a, el.deviceValue + 1);
	Pdefn(\t).source = { Pbjorklund2(~tl.get(\a), ~th.get(\a))/~tg.get(\a)};
};


// glitchers

c.elAt(\pad, 0).action = {arg el;
	(el.type == 'padUp').if {
		~kg.set(\a, 4);
		Pdefn(\k).source = { Pbjorklund2(~kl.get(\a), ~kh.get(\a))/~kg.get(\a)}

	};
	(el.type == 'pad').if {
		~kg.set(\a, 4 * el.value * 100);
		Pdefn(\k).source =  {Pbjorklund2(~kl.get(\a), ~kh.get(\a))/~kg.get(\a)}

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
)