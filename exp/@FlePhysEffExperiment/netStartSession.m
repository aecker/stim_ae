function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Initalization.
%
% AE 2009-03-15

% Create randomization. Needs to be done before initialization
rnd = FlePhysEffRandomization(params.barColor,params.trajectoryAngle, ...
                              params.dx,params.direction, ...
                              params.numFlashLocs,params.flashStop);
e = set(e,'randomization',rnd);

% call parent's init function
[e,retInt32,retStruct,returned] = initSession(e,params);
