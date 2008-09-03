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
