function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2009-03-15

% Initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% Use postStimTime to realize interTrialTime
interTrialTime = getParam(e,'interTrialTime');
e = setTrialParam(e,'postStimulusTime',interTrialTime);
