function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Trial outcome
% AE 2010-10-24

% call parent's implementation
[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netTrialOutcome(e.TrialBasedExperiment,params);

% since we rely on the stimulus being removed by
% TrialBasedExperiment/netTrialOutcome, we have to log stimulus offset
% event here
e = addEvent(e,'endStimulus',getLastSwap(e));
