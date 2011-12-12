function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

e = clearScreen(e);

% read outcome
e = setTrialParam(e,'correctResponse',logical(params.correctResponse));
e = setTrialParam(e,'validTrial',true);
fprintf('correctResponse = %d\n',params.correctResponse)


if getParam(e,'playResponseSounds')
    if params.correctResponse
        e = playSound(e,'correctResponse');
    else
        e = playSound(e,'incorrectResponse');
    end
end

retInt32 = 0;
returned = false;
% The try part will work with the old acquisition system. For the new acq
% system, the random reward scheme needs to be implemented at the labview
% level as well - I do not find a need for randomReward at the moment - MS.
try
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
    retStruct = struct('reward',int32(rewardAmount));
catch
    retStruct = struct;
end



