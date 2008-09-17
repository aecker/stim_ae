function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% call parent's netStartTrial
[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netStartTrial(e.TrialBasedExperiment,params);

% Because stupid Matlab doesn't know virtual functions...
e = initTrial(e);

% return variable delayTime to LabView
retStruct.delayTime = getParam(e,'delayTime');
