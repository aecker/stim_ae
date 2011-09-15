function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2011-09-13

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% determine condition to show
r = get(e,'randomization');
level = getLevel(r);
stepSize = getParam(e,'stepSize');
signalFraction = 1 / (1 + exp(-level * stepSize));
e = setTrialParam(e,'signalFraction',signalFraction);
e = setTrialParam(e,'level',level);
e = setTrialParam(e,'threshold',getThreshold(r));

% Set the delay time to the stimulus time 
e = setTrialParam(e,'delayTime',getParam(e,'stimulusTime'));
