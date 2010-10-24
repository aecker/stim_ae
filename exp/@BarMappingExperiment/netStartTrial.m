function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% call parent's initialization
[e,retInt32,retStruct,returned] = initTrial(e,params);

% Do we need to reinitialize the randomization?
data = get(e,'data');
if getParam(e,'barLength') ~= getPrev(data,'barLength') || ...
        getParam(e,'barWidth') ~= getPrev(data,'barWidth')
    e = initRand(e);
    e = precompTextures(e);
end

% write stimulusTime parameter
delayTime = getParam(e,'delayTime');
e = setTrialParam(e,'stimulusTime',delayTime);
