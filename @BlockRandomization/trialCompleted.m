function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = false;
mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.conditionPool(r.lastCondition) = [];
end

% pool empty -> new block
if isempty(r.conditionPool)
    r = resetPool(r);
    canStop = true;
end
