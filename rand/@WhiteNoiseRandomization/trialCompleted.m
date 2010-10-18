function [r,mustStop] = trialCompleted(r,valid,varargin)

mustStop = false;

% trial not successfully completed -> restore pool from backup
if ~valid
    r.pool = r.backup;
end
