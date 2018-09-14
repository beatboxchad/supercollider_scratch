
c = MKtl(\akai, "akai-lpd8")

c.elAt(\kn, 0).action = {arg el; a.set(\speed, el.value)};
c.elAt(\kn, 1).action = {arg el; a.set(\feedback, el.value * 2)};
c.elAt(\kn, 2).action = {arg el; a.set(\pitchdepth, el.value - 0.5)};
c.elAt(\kn, 3).action = {arg el; a.set(\pitchspeed, el.value* 10)};