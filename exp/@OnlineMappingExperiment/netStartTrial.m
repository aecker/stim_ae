function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% call parent's netStartTrial
[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netStartTrial(e.TrialBasedExperiment,params);
