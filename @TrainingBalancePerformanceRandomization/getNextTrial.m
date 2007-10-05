function [r,indices,condIndex] = getNextTrial(r)
% Return parameters for given condition.

r.performanceHistory
performanceVector = sum(r.performanceHistory,2)/size(r.performanceHistory,2);
errorVector = 1-performanceVector

% Allow all conditions some probability.  This is like saying each
% condition has a 10% error rate.
errorVector = errorVector + .2; 

% Normalize errors among the classes to determine the probability of 
% showing each stimulus.
errorVector = errorVector / sum(errorVector);
errorVector = cumsum(errorVector);

% Pick the one which the random variable is less of equal than the element
% and greater than the previous element
a = rand(1);
condIndex = find((a <= errorVector) & (a > [0; errorVector(1:end-1)]));

r.lastCondition = condIndex;

% get parameter indices
indices = conditionToIndices(r,condIndex);
