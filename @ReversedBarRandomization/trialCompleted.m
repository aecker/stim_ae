function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = false;
mustStop = false;

% trial successfully completed -> count up
if valid
    if r.initMapTrials > 0
        r.initMapTrials = r.initMapTrials - 1;
    else
        r.currentTrial = r.currentTrial + 1;
    end
end

% pool exhausted?
if r.currentTrial > length(r.conditionPool)
    r.currentTrial = 1;
    r = resetPool(r);
    canStop = true;
end
