/*
Consider two groups of 10 people each. In the first group, as expected, the percentage of people
with lung cancer among smokers is higher than among non-smokers. In the second group, the same is
the case. But if we consider the 20 people of the two groups together, then the situation is the opposite:
the proportion of people with lung cancer is higher among non-smokers than among smokers! Can this
be true?
*/

num(X):- between(1,7,X). % below, e.g. SNC1 denotes "num. smokers with no cancer group 1".

p:- 
	num(SC1), num(SNC1), num(NSC1), num(NSNC1), 10 is SC1+SNC1+NSC1+NSNC1,
	SC1/(SC1+SNC1) > NSC1/(NSC1+NSNC1),

	num(SC2), num(SNC2), num(NSC2), num(NSNC2), 10 is SC2+SNC2+NSC2+NSNC2,
	SC2/(SC2+SNC2) > NSC2/(NSC2+NSNC2),

	(SC1+SC2)/(SC1+SNC1+SC2+SNC2) < (NSC1+NSC2)/(NSC1+NSNC1+NSC2+NSNC2),
	write([ SC1,SNC1,NSC1,NSNC1,SC2,SNC2,NSC2,NSNC2]), nl,
	halt.
