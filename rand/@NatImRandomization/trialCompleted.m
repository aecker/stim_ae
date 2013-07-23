function [r, mustStop] = trialCompleted(r, valid, varargin)

% Indicates whether the experiment should be stopped (because this was the
% last trial)
mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.conditionPool(r.lastCondition) = [];
end

% pool empty -> new block
if isempty(r.conditionPool)
    r = resetPool(r);
end

