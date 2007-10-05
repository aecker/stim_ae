function r = BlockNonrandom(numValues,numTrials)
% Multidimensional block randomization.
%    r = BlockNonrandom(numValues); This will simply alternate showing
%    r.repNum of the given condition before moving on
%
% JC 2007-3-14

% Number of possible values for each parameter
r.numValues = numValues;

% Number of trials to run
r.numTrials = numTrials;

% Number of times to repeat a given stimulus
r.repNum = 50;
r.curRep = 0;  % current count of that repeat

% Pool of conditions remaining in the current block.
% In each request a random number is drawn an the according indices are
% returned.
r.conditionPool = 1:prod(numValues);
r.lastCondition = [];

% Create class object
r = class(r,'BlockNonrandom');
