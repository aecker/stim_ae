function [r,lastTrial] = trialCompleted(r,valid,correct)

% Indicates whether this was the last trial
lastTrial = false;

% trial successfully completed -> remove condition from pool
if valid
    r.conditionPool(r.lastCondition) = [];
    r.numTrials = r.numTrials - 1;
    
    % last trial?
    if r.numTrials == 0
        lastTrial = true;
    end
end

% pool empty -> new block
if isempty(r.conditionPool)
    r.conditionPool = 1:prod(r.numValues);
end

% fprintf('BlockRandomization: %d trials remaining\n',r.numTrials)
