function r = TrainingBalancePerformanceRandomization(numValues,numTrials)
% Randomization based on the recent history of performance
%    r = TrainingBalancePerformanceRandomization(numValues); will create a Blockrandomization
%    object. numValues is an n-dimensional vector, where n is the total
%    number of parameters.
% this randomization method will independently track the performance on
% each of the stimulus conditions, and when that performance is greater
% than the performance on the other stimuli decrease the percentage of
% trials it is presented.  Clearly for stimulus that are designed to be
% hard to distinguish this is a poor method, but for training purposes it
% will hopefully counterbalance against their performance imbalances
%
% JC 2007-3-14

% Number of possible values for each parameter
r.numValues = numValues;

% Number of trials to run
r.numTrials = numTrials;

% Number of trials to track performance over
r.performanceHistorySize = 10;

% Track how many right since we adjusted the threshold
r.correctSinceAdjust = 0;

% This matrix will track the performance history
r.performanceHistory(prod(numValues),r.performanceHistorySize) = 0;
for(a = 1:prod(numValues))
    for(b = 1:r.performanceHistorySize)
        r.performanceHistory(a,b) = 0; %(rand > .5); 
        %Initialize like entire history is errors to encourage the
        %algorithm to show all conditions initially equally.  Then whatever
        %he is doing well on will be the only thing changing and will
        %become less probable.
    end
end

% The pool of conditions is no longer used as it is constantly
% "replenished"
r.lastCondition = [];

% Create class object
r = class(r,'TrainingBalancePerformanceRandomization');
