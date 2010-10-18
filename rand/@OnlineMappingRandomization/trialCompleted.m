function [r,mustStop] = trialCompleted(r,validTrial,correctTrial)
% Mani
% June-04-2008
mustStop = false;
if validTrial
    r.nTrialsCompleted = r.nTrialsCompleted + 1;
    if r.nTrialsCompleted == r.nTrials
        mustStop =  true;
        r.nTrialsCompleted = 0;
    end
end
