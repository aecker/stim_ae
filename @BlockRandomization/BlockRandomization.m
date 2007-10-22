function r = BlockRandomization
% Multidimensional block randomization.
%    R = Blockrandomization; creates a Blockrandomization object
%    R = init(R,params); initializes the randomization
%
% AE 2007-10-08

% Changes:
% --------
% AE 2007-10-05: Now passing full parameter structure rather than just number of
%                different values. This allows for more flexibility, since some
%                parameters can be treated in a special way.
% AE 2006-12-05: initial release.

% internal fields
r.conditions = repmat(struct,0,0);
r.conditionPool = [];
r.lastCondition = [];

% Create class object
r = class(r,'BlockRandomization');
