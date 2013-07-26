function r = NatImRandomization(varargin)
% Natural images randomization.
% AE 2013-07-10

r.conditions = struct([]);
r.conditionPool = [];
r.lastCondition = [];

% Create class object
r = class(r, 'NatImRandomization');
