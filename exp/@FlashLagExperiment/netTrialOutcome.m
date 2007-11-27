function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

e = clearScreen(e);

% read outcome
e = setTrialParam(e,'correctResponse',logical(params.correctResponse));
e = setTrialParam(e,'validTrial',true);


% If the monkey responds correctly, he will be rewarded with a certain
% probability.

r = get(e,'randomization');
isReward = getReward(r,logical(params.correctResponse));
if getParam(e,'randReward')
    rewardAmount = isReward * rand(1) * getParam(e,'rewardAmount');
else
    rewardAmount = isReward * getParam(e,'rewardAmount');
end
e = setTrialParam(e,'rewardAmount',rewardAmount);

retInt32 = 0;
retStruct = struct('reward',int32(rewardAmount));
returned = false;



