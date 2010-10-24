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
[e,retInt32,retStruct,returned] = initTrial(e,params);

% target information needs to go back to LabView
targetLocation = getParam(e,'targetLocation');
leftTarget = targetLocation;
rightTarget = targetLocation .* [-1; 1];
e = setTrialParam(e,'leftTarget',leftTarget);
e = setTrialParam(e,'rightTarget',rightTarget);
retStruct.leftTarget = leftTarget;
retStruct.rightTarget = rightTarget;
retStruct.targetRadius = getParam(e,'targetRadius');
