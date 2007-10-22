function r = MovingBarRandomization()
% Custom randomization for MovingBarExperiments
%
% AE & PhB 2007-10-09

r.numSubBlocks = NaN;
r.movingTrials = NaN;
r.initMapTrials = NaN;
r.mapTrials = NaN;

r.conditions = repmat(struct,0,0);

r.conditionPool = [];
r.currentTrial = 1;

% Create class object
r = class(r,'MovingBarRandomization');
