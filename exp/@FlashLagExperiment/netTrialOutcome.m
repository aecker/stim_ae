function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netTrialOutcome(e.TrialBasedExperiment,params);

r = get(e,'randomization');
isReward = getReward(r,logical(params.correctResponse));
retStruct.reward = int32(isReward * getParam(e,'rewardAmount'));
