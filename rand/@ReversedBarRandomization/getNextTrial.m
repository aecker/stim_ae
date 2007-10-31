function [r,condIndex] = getNextTrial(r)
% Return parameters for given condition.

if r.initMapTrials > 0
    condIndex = 1;
else   
    condIndex = r.conditionPool(r.currentTrial);
end
