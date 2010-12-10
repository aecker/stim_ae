function [r,mustStop] = trialCompleted(r,valid,correct)
% End of trial
% AE 2010-10-24

% if the trial was valid remove current condition from the pool and update
% the threshold
if valid
    r.pools{r.currentLevel}(r.currentCondition) = [];

    % update threshold estimate depending on correct/wrong response
    if correct
        r.threshold = r.threshold + r.correct;
        fprintf('Correct response | New threshold: %.2f\n',r.threshold)
    else
        r.threshold = r.threshold + r.wrong;
        % bound threshold from above to avoid ambiguity due to circularity
        % of quantities such as orientation
        r.threshold = min(r.threshold,r.maxLevel);
        fprintf('Wrong response   | New threshold: %.2f\n',r.threshold)
    end
else
    fprintf('Invalid trial    | New threshold: %.2f\n',r.threshold)
end

mustStop = false;

