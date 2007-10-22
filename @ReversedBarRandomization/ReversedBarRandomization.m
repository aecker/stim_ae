function r = ReversedBarRandomization()
% Custom randomization for MovingBarExperiments
%
% AE & PhB 2007-10-09

r.initMapTrials = NaN;
r.exceptionRate = NaN;

r.conditions = repmat(struct,0,0);

r.conditionPool = [];
r.currentTrial = 1;
r.nNormalTrials = NaN;

% Create class object
r = class(r,'ReversedBarRandomization');
