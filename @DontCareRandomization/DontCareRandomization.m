function r = DontCareRandomization(numValues,numTrials)
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

% Create class object
r = class(r,'DontCareRandomization');
