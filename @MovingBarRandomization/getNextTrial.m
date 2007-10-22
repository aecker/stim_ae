function [r,condIndex] = getNextTrial(r)
% Return parameters for given condition.

if r.currentTrial > length(r.conditionPool)
    error('All trials completed. LabView should have read out the ''mustStop'' return value of trialCompleted!')
end

condIndex = r.conditionPool(r.currentTrial);
