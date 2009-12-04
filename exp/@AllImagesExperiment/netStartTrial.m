function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Initialize trial.
% AE 2008-08-04

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
stimTime = getParam(e,'stimulusTime');
retStruct.delayTime = stimTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);

