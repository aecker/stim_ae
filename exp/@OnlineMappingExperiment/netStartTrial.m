function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Initialize trial.
% AE 2008-08-05

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% write stimulusTime parameter
delayTime = getParam(e,'delayTime');
e = setTrialParam(e,'stimulusTime',delayTime);
