function [r,condIndex] = getNextTrial(r)
% Return parameters for given condition.

% draw random condition
condIndex = ceil(rand(1) * length(r.conditionPool));
r.lastCondition = condIndex;
