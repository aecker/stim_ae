function [r,mustStop] = trialCompleted(r,valid,correct)

mustStop = false;

% determine "block" condition
cond = r.conditionPool(r.currentTrial);

% notify block randomization
r.block(cond) = trialCompleted(r.block(cond),valid,correct);

% go to next trial, if this one was valid
if valid
    r.currentTrial = r.currentTrial + 1;
end

% refill condition pool if we're through
if r.currentTrial > length(r.conditionPool)
    r = resetPool(r);
end


