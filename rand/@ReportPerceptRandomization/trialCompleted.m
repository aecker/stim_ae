function [r,mustStop] = trialCompleted(r,valid,correct)

mustStop = false;

% He's advanced by one trial within the block if he responds correctly
% except on probe trial where he's advanced to the next trial irrespective
% of his response
cond = r.conditionPool(r.currentTrial);
if (valid && correct) || ...
        r.conditions(cond).trialType == ReportPerceptRandomization.PROBE
    r.currentTrial = r.currentTrial + 1;
end

if r.currentTrial > length(r.conditionPool)
    r = resetPool(r);
end
