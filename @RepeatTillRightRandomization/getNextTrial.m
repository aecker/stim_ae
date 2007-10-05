function [r,indices,condIndex] = getNextTrial(r)
% Return parameters for given condition.

if(r.previousCorrect)
    % Draw random condition
    condIndex = ceil(rand(1) * prod(r.numValues));
    r.lastCondition = condIndex;
    
    r.previousCorrect = false;
else
    % Repeat previous condition until done correctly
    condIndex = r.lastCondition;
end

% get parameter indices
indices = conditionToIndices(r,condIndex);