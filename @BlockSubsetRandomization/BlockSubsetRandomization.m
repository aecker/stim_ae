function r = BlockRandomization(numValues,numTrials)
% Multidimensional block randomization.
%    r = Blockrandomization(numValues); will create a Blockrandomization
%    object. numValues is an n-dimensional vector, where n is the total
%    number of parameters.
%
% AE 2006-12-05

% Number of possible values for each parameter
r.numValues = numValues;

% Number of trials to run
r.numTrials = numTrials;

% Pool of conditions remaining in the current block.
% In each request a random number is drawn an the according indices are
% returned.
%r.pools = [[1 1 4 4 ];[2 2 3 3]];
r.pools = [[1*ones(1,500) 2*ones(1,500)];[3*ones(1,500) 4*ones(1,500)]];

r.conditionPool = r.pools(ceil(rand * size(r.pools,1)),:);
r.lastCondition = [];

% Create class object
r = class(r,'BlockSubsetRandomization');
