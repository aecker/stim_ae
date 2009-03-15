function e = initTrial(e)
% Initialize trial.
% AE 2009-03-15

% use postStimTime to realize interTrialTime
interTrialTime = getParam(e,'interTrialTime');
e = setTrialParam(e,'postStimulusTime',interTrialTime);
