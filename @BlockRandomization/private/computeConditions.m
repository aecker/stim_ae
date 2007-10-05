function r = computeConditions(r,params)
% Build condition structure
% AE 2007-10-05

% number of values per parameter
paramNames = fieldnames(params);
n = length(paramNames);
numValues = zeros(n,1);
for i = 1:n
    numValues(i) = size(params.(f{i}),2);
end

% build condition structure
for i = 1:prod(numValues)
    indices = conditionToIndices(r,i);
    for j = 1:n
        r.conditions(i).(paramNames{j}) = params.(paramNames{j})(:,indices(j));
    end
end
