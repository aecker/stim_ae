function r = BlockRandomization(params,numTrials)
% Multidimensional block randomization.
%    r = Blockrandomization(numValues); will create a Blockrandomization
%    object. 
%
% AE 2007-10-05

% Changes:
% --------
% AE 2007-10-05: Now passing full parameter structure rather than just number of
%                different values. This allows for more flexibility, since some
%                parameters can be treated in a special way.
% AE 2006-12-05: initial release.

% internal fields
r.numTrials = numTrials;
r.conditions = struct;
r.conditionPool = [];
r.lastCondition = [];

% Create class object
r = class(r,'BlockRandomization');

% determine conditions
r = computeConditions(r,params);
r = resetPool(r);
