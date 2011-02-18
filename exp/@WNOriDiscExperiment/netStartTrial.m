function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2011-02-18

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% determine condition to show
r = get(e,'randomization');
level = getLevel(r);
signalFraction = 1 / exp(-level);
e = setTrialParam(e,'signalFraction',signalFraction);
e = setTrialParam(e,'level',level);
e = setTrialParam(e,'threshold',getThreshold(r));
