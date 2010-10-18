function [r,mustStop] = trialCompleted(r,valid,varargin)

mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.conditionPool(r.conditionIdx) = [];
end

if isempty(r.conditionPool)
  r = resetPool(r);
end
