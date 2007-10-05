function e = trialOutcome(e)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

% clear screen
e = clearScreen(e);

% read outcome
con = get(e,'con');
correctResponse = pnet(con,'read',1,'uint8');
e.data = set(e.data,'correctResponse',logical(correctResponse));
e.data = set(e.data,'validTrial',true);

if(correctResponse)
    e = playSoundLocal(e,'correctResponse');
else
    e = playSoundLocal(e,'incorrectResponse');
end

% If the monkey responds correctly, he will be rewarded with a certain
% probability.
reward = rand(1) <= e.curParams.rewardProb && correctResponse;
pnet(con,'write',uint8(reward));
