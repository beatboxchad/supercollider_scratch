(
c = MKtl(\akai, "akai-lpd8");
// quadratic beat machine mode

// hits per cycle
c.elAt(\kn, 0).action = {arg el; ~kl.set(\a, el.value.linlin(0,1, 1, ~kh.get(\a)).round)};
// cycle size
c.elAt(\kn, 4).action = {arg el; ~kh.set(\a, el.deviceValue + 1)};

// and so on
c.elAt(\kn, 1).action = {arg el; ~sl.set(\a, el.value.linlin(0,1, 1, ~sh.get(\a)).round)};
c.elAt(\kn, 5).action = {arg el; ~sh.set(\a, el.deviceValue + 1)};

c.elAt(\kn, 2).action = {arg el; ~hl.set(\a,
	el.value.linlin(0,1, 1, ~hh.get(\a)).round)};
c.elAt(\kn, 6).action = {arg el; ~hh.set(\a, el.deviceValue + 1)};

c.elAt(\kn, 3).action = {arg el; ~tl.set(\a, el.value.linlin(0,1, 1, ~th.get(\a)).round)};
c.elAt(\kn, 7).action = {arg el; ~th.set(\a, el.deviceValue + 1)};

)