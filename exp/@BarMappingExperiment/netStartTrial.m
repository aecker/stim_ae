function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% call parent's netStartTrial
[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netStartTrial(e.TrialBasedExperiment,params);

% Do we need to reinitialize the randomization?
data = get(e,'data');
if getParam(e,'barLength') ~= getPrev(data,'barLength') || ...
        getParam(e,'barWidth') ~= getPrev(data,'barWidth')
    e = initRand(e);
    e = precompTextures(e);
end
