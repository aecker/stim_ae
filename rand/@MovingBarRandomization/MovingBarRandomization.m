function r = MovingBarRandomization(numSubBlocks,movingTrials,initMapTrials, ...
                                    mapTrials)
% Custom randomization for MovingBarExperiments
%
% AE & PhB 2007-12-17

r.numSubBlocks = numSubBlocks;
r.movingTrials = movingTrials;
r.initMapTrials = initMapTrials;
r.mapTrials = mapTrials;

r.conditions = repmat(struct,0,0);

r.conditionPool = [];
r.currentTrial = 1;

% Create class object
r = class(r,'MovingBarRandomization');
