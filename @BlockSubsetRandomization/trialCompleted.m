function [r,lastTrial] = trialCompleted(r,valid,correct)

% Indicates whether this was the last trial
lastTrial = false;

% trial successfully completed -> remove condition from pool
if correct
    r.conditionPool(r.lastCondition) = [];
    r.numTrials = r.numTrials - 1;
    
    % last trial?
    if r.numTrials == 0
        lastTrial = true;
    end
end

% pool empty -> new block
if isempty(r.conditionPool)
    r.conditionPool = r.pools(ceil(rand * size(r.pools,1)),:);
    r.lastCondition = [];
end

% fprintf('BlockRandomization: %d trials remaining\n',r.numTrials)
