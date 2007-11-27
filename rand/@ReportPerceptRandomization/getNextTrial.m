function [r,condIndex] = getNextTrial(r)
% Return parameters for given condition.

condIndex = r.conditionPool(r.currentTrial);
