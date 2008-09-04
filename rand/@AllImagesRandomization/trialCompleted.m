function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.currentTrial = r.currentTrial + 1;
end


if r.currentTrial > length(r.conditionPool)
    mustStop = true;
end
