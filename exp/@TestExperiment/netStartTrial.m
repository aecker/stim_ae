function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% check if maxBlockSize has changed
r = get(e,'randomization');
if isfield(params,'maxBlockSize') && params.maxBlockSize ~= getMaxBlockSize(r)
    r = setMaxBlockSize(r,params.maxBlockSize);
    data = get(e,'data');
    data = setConditions(data,getConditions(r));
    e = set(e,'data',data);
end

% check if expMode has changed
if isfield(params,'expMode') && params.expMode ~= isExpMode(r)
    r = setExpMode(r,params.expMode);
end
e = set(e,'randomization',r);

% call parent's netStartTrial
[e.TrialBasedExperiment,retInt32,retStruct,returned] = ...
    netStartTrial(e.TrialBasedExperiment,params);

