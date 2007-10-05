function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

% clear screen??
% e = clearScreen(e);
disp('We might need a clearScreen here (removed by AE 2007-10-05)')

% read outcome
e.data = setTrialParam(e.data,'correctResponse',logical(params.correctResponse));

if params.correctResponse
    e = playSound(e,'correctResponse');
else
    e = playSound(e,'incorrectResponse');
end

% If the monkey responds correctly, he will be rewarded with a certain
% probability.
reward = (rand(1) < getParam(e,'rewardProb') && params.correctResponse);

retInt32 = int32(reward);
retStruct = struct;
returned = false;
