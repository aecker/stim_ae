function [r,indices,condIndex] = getNextTrial(r)
% Return parameters for given condition.

% draw random condition
condIndex = ceil(rand(1) * prod(r.numValues));

% get parameter indices
indices = conditionToIndices(r,condIndex);
