function conditions = getConditions(r)
% Get a matrix of all conditions used in the randomizatin scheme.
% We return a M x N matrix containing sets of indices. M, the number of
% rows is the number of different conditions. N, the number of columns is
% the total number of parameters.

nCond  = prod(r.numValues);
conditions = zeros(nCond,length(r.numValues));
for i = 1:nCond
    conditions(i,:) = conditionToIndices(r,i);
end
