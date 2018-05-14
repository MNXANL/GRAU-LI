:- usemodule(library(clpfd))





main :-
	L = [X11, X12, X13, X14, X15, X16, X17, X18, X19, X21, X22, X23, X24, X25, X26, X27, X28, X29, X31, X32, X33, X34, X35, X36, X37, X38, X39, X41, X42, X43, X44, X45, X46, X47, X48, X49, X51, X52, X53, X54, X55, X56, X57, X58, X59, X61, X62, X63, X64, X65, X66, X67, X68, X69, X71, X72, X73, X74, X75, X76, X77, X78, X79, X81, X82, X83, X84, X85, X86, X87, X88, X89, X91, X92, X93, X94, X95, X96, X97, X98, X99],

	L ins 1..9,
	alldifferent([X11, X12, X13, X14, X15, X16, X17, X18, X19]),
	alldifferent([X21, X22, X23, X24, X25, X26, X27, X28, X29]),
	alldifferent([X31, X32, X33, X34, X35, X36, X37, X38, X39]),
	alldifferent([X41, X42, X43, X44, X45, X46, X47, X48, X49]),
	alldifferent([X51, X52, X53, X54, X55, X56, X57, X58, X59]),
	alldifferent([X61, X62, X63, X64, X65, X66, X67, X68, X69]),
	alldifferent([X71, X72, X73, X74, X75, X76, X77, X78, X79]),
	alldifferent([X81, X82, X83, X84, X85, X86, X87, X88, X89]),
	alldifferent([X91, X92, X93, X94, X95, X96, X97, X98, X99]),
	% alldistinct() > alldifferent(), 	si es posible usarlo (porque propaga menos)
	


	true.