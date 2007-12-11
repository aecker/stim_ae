function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

% trial successfully completed -> remove condition from pool
if valid
    r.currentTrial = r.currentTrial + 1;
end

% put these lines back in, if we want canStop only after completed blocks to be
% true. currently, it can stop after every trial

% can stop after each completed block
% blockSize = r.numSubBlocks * (r.movingTrials + r.mapTrials);
% if mod(r.currentTrial - r.initMapTrials,blockSize) == 1
%   canStop = true;
%end

if r.currentTrial > length(r.conditionPool)
    mustStop = true;
end
