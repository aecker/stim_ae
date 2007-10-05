function indices = conditionToIndices(r,condIndex)
% Returns the set of indices for each parameter given a condition number.

n = length(r.numValues);
[t{1:n}] = ind2sub(r.numValues,mod(condIndex,r.numRepPerBlock));
indices = [t{:}];
