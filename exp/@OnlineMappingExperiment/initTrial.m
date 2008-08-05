function e = initTrial(e)
% Initialize trial.
% AE 2008-08-05

% write stimulusTime parameter
delayTime = getParam(e,'delayTime');
e = setTrialParam(e,'stimulusTime',delayTime);
