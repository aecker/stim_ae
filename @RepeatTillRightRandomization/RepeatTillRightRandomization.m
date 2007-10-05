function r = RepeatTillRightRandomization(numValues,numTrials)
% Multidimensional block randomization.
%    r = TrainingBalanceRandomization(numValues); will create a Blockrandomization
%    object. numValues is an n-dimensional vector, where n is the total
%    number of parameters.
%
% AE 2006-12-05

% Number of possible values for each parameter
r.numValues = numValues;

% Number of trials to run
r.numTrials = numTrials;

% Track if the previous trial was done correctly
r.previousCorrect = true;

% Need to track the last condition so can repeat it
r.lastCondition = 0;

% Create class object
r = class(r,'RepeatTillRightRandomization');
