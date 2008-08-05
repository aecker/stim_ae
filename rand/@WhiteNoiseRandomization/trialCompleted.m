function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

% trial successfully completed -> remove locations from pool
if ~valid
    r.pool = r.backup;
end
