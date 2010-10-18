function [r,mustStop] = trialCompleted(r,valid,varargin)

mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.currentTrial = r.currentTrial + 1;
end

if r.currentTrial > length(r.conditionPool)
    mustStop = true;
end
