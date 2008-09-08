function e = initSession(e,params,expType)
% Initalization.
%   Here we generate the bar texture.
%
% AE 2008-09-03

% set randomization parameters
rnd = FlePhysRandomization(params.barColor,params.trajectoryAngle, ...
                           params.dx,params.direction,params.numFlashLocs);
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
