function [r,lastTrial] = trialCompleted(r,valid,correct)

% Indicates whether this was the last trial
lastTrial = false;
valid
correct
if valid | correct

<<<<<<< .mine
if valid
=======
    % Prepend the current trial success to the vector of performance
    r.performanceHistory(r.lastCondition,:) = ...
        [correct r.performanceHistory(r.lastCondition,1:end-1)];
>>>>>>> .r471

<<<<<<< .mine
    % Prepend the current trial success to the vector of performance
    r.performanceHistory(r.lastCondition,:) = ...
        [correct r.performanceHistory(r.lastCondition,1:end-1)];

	r.correctSinceAdjust = r.correctSinceAdjust + 1;
	
=======
    r.lastCondition
    
>>>>>>> .r471
    r.numTrials = r.numTrials - 1;
    
    % last trial?
    if r.numTrials == 0
        lastTrial = true;
    end
end
