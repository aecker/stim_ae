function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2009-07-27

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
ni = getParam(e,'imPerTrial');
imTime = getParam(e,'imTime');
blankTime = getParam(e,'blankTime');
stimTime = ni*(imTime+blankTime);
retStruct.delayTime = stimTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);
