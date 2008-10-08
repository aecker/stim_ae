function [r,canStop,mustStop] = trialCompleted(r,valid,correct)

canStop = true;
mustStop = false;

cond = r.conditionPool(r.currentTrial);
if (valid && correct) || ...
        r.conditions(cond).trialType == FleHumanRandomization.PROBE
    r.currentTrial = r.currentTrial + 1;
end

if r.currentTrial > length(r.conditionPool)
    r = resetPool(r);
end
