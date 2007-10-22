function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = false;
mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.currentTrial = r.currentTrial + 1;
end

% can stop after each completed block
blockSize = r.numSubBlocks * (r.movingTrials + r.mapTrials);
if mod(r.currentTrial - r.initMapTrials,blockSize) == 1
    canStop = true;
end

if r.currentTrial > length(r.conditionPool)
    mustStop = true;
end
