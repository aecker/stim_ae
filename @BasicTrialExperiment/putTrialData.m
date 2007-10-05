function e = putTrialData(e,type,value)
% Put data into the current trial field of the StimulationData structure.
% AE 2007-02-22

e.data = set(e.data,type,value);
