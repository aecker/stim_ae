function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netTrialOutcome(e.TrialBasedExperiment,params);

%TODO: Remove try catch block when transitioned to new state chart
try
    
    isReward = 1;
    if getParam(e,'randReward')
        rewardAmount = isReward * rand(1) * getParam(e,'rewardAmount');
    else
        rewardAmount = isReward * getParam(e,'rewardAmount');
    end
    e = setTrialParam(e,'rewardAmount',rewardAmount);
    retStruct.reward = int32(rewardAmount);
    
catch
end

