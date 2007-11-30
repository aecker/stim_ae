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
    mu = getParam(e,'rewardAmount');
    a = 1.5;
    randAmount = 0.3 * mu + gamrnd(a,0.7 * mu / a,1);
    rewardAmount = isReward * randAmount;
else
    rewardAmount = isReward * getParam(e,'rewardAmount');
end
e = setTrialParam(e,'rewardAmount',rewardAmount);
fprintf('reward: %dms\n',int32(rewardAmount))

retInt32 = 0;
retStruct = struct('reward',int32(rewardAmount));
returned = false;



