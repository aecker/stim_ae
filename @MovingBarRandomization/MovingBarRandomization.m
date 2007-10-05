function r = MovingBarRandomization(numValues,numTrials)
% Custom randomization for MovingBarExperiments
%
% AE & PhB 2007-09-28

% Number of possible values for each parameter
r.numValues = numValues;

% Number of trials to run
r.numTrials = numTrials;

% Pool of conditions remaining in the current block.
% In each request a random number is drawn an the according indices are
% returned.
r.conditionPool = 1:prod(numValues);
r.lastCondition = [];

% Create class object
r = class(r,'MovingBarRandomization');
