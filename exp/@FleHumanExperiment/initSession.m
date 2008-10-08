function e = initSession(e,params,expType)
% Initalization
% AE & PhB 2008-10-08

% set randomization parameters
rnd = FleHumanRandomization(params.maxBlockSize,params.speed, ...
                            params.contrast,params.direction, ...
                            params.flashOffsets,params.offsetThreshold);
e = set(e,'randomization',rnd);

% call parent's init function
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% Since we overwrote initSession, we need to manually initialize the 
% conditions now. TrialBasedExperiment/initSession is calling initCondition
% automatically, but since the above call is running only on the parent, it 
% calls TrialBasedExperiment/initCondition instead of 
% GratingExperiment/initSession.
for i = 1:getNumConditions(e)
    e = initCondition(e,i);
end
