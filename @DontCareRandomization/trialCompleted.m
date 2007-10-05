function [r,lastTrial] = trialCompleted(r,valid,correct)
disp(sprintf(['Trials remaining: ' num2str(r.numTrials)]));

% Indicates whether this was the last trial
lastTrial = false;

% trial successfully completed -> remove condition from pool
if valid
    r.numTrials = r.numTrials - 1;
    
    % last trial?
    if r.numTrials == 0
        lastTrial = true;
    end
end
