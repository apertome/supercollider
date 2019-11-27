// Sound Files and Comb Filters
// inspired by https://www.youtube.com/watch?v=8hFJIm_o6O8&t=520s

//s.boot;

//s.meter;
//s.plotTree;

s.reboot;
//s.quit;


// Dictionary


// (
// b = Dictionary.new;
// PathName("/Users/mj82/samples/").entries.do{
// 	arg subfolder;
// 	b.add(subfolder.folderName.asSymbol ->
// 		Array.fill(
// 			subfolder.entries.size,
// 			{
// 				arg i;
// 				Buffer.read(s, subfolder.entries[i].fullPath);
// 			}
// 		);
// 	);
// };
// )

//~sndname = Buffer.read(s, "/Users/mj82/samples/freesound/494480__erokia__piano-ambiance-msfxp4-200-120-bpm.wav");
~sndname = Buffer.read(s, "/Users/mj82/samples/apertome/ap musicbox1.wav");
~sndname = Buffer.read(s, "/Users/mj82/samples/apertome/ap bells1 all xy 90deg1.wav");
~sndname = Buffer.read(s, "/Users/mj82/samples/apertome/drum1 reaper kickish 2layers ms 96khz.wav");


//~sndname = Buffer.read(s, "/Users/mj82/samples/freesound/494836__volpone__u-bahn-berlin-announcer-zug-nach-hermmanstrasse.wav");
~sndname.play;


// PlaySynth

(
SynthDef.new(\play,{
	arg amp=0.5, atk=0.001, rel=0.8, c1=1, c2(-1), buf=0, rate=1, spos=0, pan=0, out=0;
	var sig, env;
	env = Env([0, 1, 0], [atk, rel], [c1, c2]).kr(2);
	sig = PlayBuf.ar(2, buf, rate, startPos: spos);
	sig = sig * env;
	pan = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);

}).add;
)

// CombL - Linearly Interpolated Comb Filter

(
SynthDef.new(\combL,{
	arg in=0, amp=0.2, deltime=0.1, decay=3,
	feedback=0.7, mix=0.5, delHz=0.22, delMul=0.1, shift=1, out=0;
	var sig, env, comb;
	env = Env([0, 1, 0], [1, 1], [1, -1]).kr(2);
	sig = In.ar(in!2);
	comb = CombL.ar(sig,
		0.3, deltime, decay,
		LFNoise1.ar([delHz, delHz], delMul)
	);
	sig = XFade2.ar(sig, comb, mix);
	//sig = PitchShift.ar(sig, 0.2, Pwhite(0.2, 5, inf));
	//sig = PitchShift.ar(sig, 0.2, shift);
	sig = FreqShift.ar(sig, shift);

	Out.ar(out, sig);

}).add;
)


// EXAMPLE 2
(

Pbindef(\mySounds,
	\instrument, \play,
	\buf, ~sndname,
	\amp, 0.55,
	\dur, 10,
	\atk, 0.001,
	\rel, 15,
	\pan, Pwhite(-0.5, 0.5, inf),
	\out, 0
).play;

Pbindef(\myComb,
	\instrument, \combL,
	\mix, 0.8,
	\amp, 0.7,
	\atk, 0.01,
	//\rel, Pwhite(0.03, 1),
	\rel, 2000,
	\deltime, Pwhite(0.005,0.1, inf),
	\decay, Pwhite(0.01, 3, inf),
	\delHz, 0.63,
	\delMul, Pwhite(0.1, 1, inf),
	\feedback, 0.99,
	\shift, Pwhite(-4000, 4000, inf),
	//\shift, 0.2,
	\out, 0
).play;

)



// EXAMPLE 1
/*
(
Pbindef(\mySounds,
	\instrument, \play,
	\buf, ~sndname,
	\amp, 0.55,
	\dur, 1,
	\atk, 0.001,
	\rel, 1,
	\pan, 0,
	\out, 0
).play;

Pbindef(\myComb,
	\instrument, \combL,
	\mix, 0.5,
	\amp, 0.7,
	\deltime, 0.01,
	\decay, 4,
	\feedback, 0.9,
	\out, 0
).play;

)
*/
