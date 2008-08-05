function e = initSession(e,params,expType)
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
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);
%--------------------------------------------------------------------------
