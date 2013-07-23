function [r, condIndex] = getNextTrial(r)
% Return parameters for given condition.

% draw random condition
ndx = ceil(rand(1) * numel(r.conditionPool));
condIndex = r.conditionPool(ndx);
r.lastCondition = ndx;

