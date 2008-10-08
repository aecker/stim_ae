function [r,condIndex] = getNextTrial(r)
% Return parameters for given condition.

condIndex = r.conditionPool(r.currentTrial);
[r.block(condIndex),blockTrial] = getNextTrial(r.block(condIndex));
condIndex = r.firstCond(condIndex) + blockTrial;
