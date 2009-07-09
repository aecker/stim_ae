function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Mani
% June-04-2008
% Create randomization
% This has to be done before calling initSession of the parent experiment
% since the randomization is initialized there.
%--------------------------------------------------------------------------
rnd = OnlineMappingRandomization(params);                    
e = set(e,'randomization',rnd);
%--------------------------------------------------------------------------
% call parent's init function
[e,retInt32,retStruct,returned] = initSession(e,params);
%--------------------------------------------------------------------------
