numMachines(3).
availableHours(100).
% #task=1, duration=15h, firstStart=17, lastFinish=49, usableMachines=[1,3]).
task(1, 15,  17, 49, [1, 3]).  
task(2, 19,   6, 66, [1, 3]).
task(3, 8,    5, 54, [1, 2, 3]).
task(4, 11,   2, 51, [1]).
task(5, 19,  15, 50, [2, 3]).
