function e = initTrial(e)
% Initialize trial.
% AE 2008-08-04

% compute post-stimulus fixation time
delayTime = getParam(e,'delayTime');
stimTime = getParam(e,'stimulusTime');
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);
