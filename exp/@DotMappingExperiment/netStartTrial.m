function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.

% call parent's initialization
[e,retInt32,retStruct,returned] = initTrial(e,params);

% Do we need to reinitialize the randomization?
data = get(e,'data');
if getParam(e,'dotSize') ~= getPrev(data,'dotSize') || ...
        getParam(e,'dotNumX') ~= getPrev(data,'dotNumX') || ...
        getParam(e,'dotNumY') ~= getPrev(data,'dotNumY')
    e = initRand(e);
end

% write stimulusTime parameter
retStruct.delayTime = getParam(e,'stimulusTime');
% delayTime = getParam(e,'delayTime');
% e = setTrialParam(e,'stimulusTime',delayTime);

