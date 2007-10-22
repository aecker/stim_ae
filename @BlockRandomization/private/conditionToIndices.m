function indices = conditionToIndices(r,numValues,condIndex)
% Returns the set of indices for each parameter given a condition number.

n = length(numValues);
[t{1:n}] = ind2sub(numValues,condIndex);
indices = [t{:}];
