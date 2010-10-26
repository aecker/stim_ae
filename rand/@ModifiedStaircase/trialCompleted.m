function [r,mustStop] = trialCompleted(r,valid,correct)
% End of trial
% AE 2010-10-24

% if the trial was valid remove current condition from the pool
if valid
    r.pools{r.currentLevel}(r.currentCondition) = [];

    % update threshold estimate depending on correct/wrong response
    if correct
        r.threshold = r.threshold + r.correct;
        fprintf('Correct response | New threshold: %.2f\n',r.threshold)
    else
        r.threshold = r.threshold + r.wrong;
        fprintf('Wrong response   | New threshold: %.2f\n',r.threshold)
    end
else
    fprintf('No response      | New threshold: %.2f\n',r.threshold)
end

mustStop = false;

