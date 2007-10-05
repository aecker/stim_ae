function [r,indices,condIndex] = getNextTrial(r)
% Return parameters for given condition.

% draw random condition
if((r.curRep == (r.repNum-1)) || isempty(r.lastCondition))
    % Shown the given stimuli r.repNum times successfully
    r.conditionPool(r.lastCondition) = [];
    
    % pool empty -> new block
    if isempty(r.conditionPool)
        r.conditionPool = 1:prod(r.numValues);
    end
    
    % Generate new random condition
    condIndex = ceil(rand(1) * length(r.conditionPool));
    r.lastCondition = condIndex;
    r.curRep = 0;
else
    condIndex = r.lastCondition;
end


% get parameter indices
indices = conditionToIndices(r,r.conditionPool(condIndex));
