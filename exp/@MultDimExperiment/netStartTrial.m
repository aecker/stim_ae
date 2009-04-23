function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2008-08-04

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
delayTime = getParam(e,'delayTime');
stimTime = getParam(e,'stimulusTime');
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);
