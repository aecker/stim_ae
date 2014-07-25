function [e, retInt32, retStruct, returned] = netStartTrial(e, params)
% Start a new trial.

[e, retInt32, retStruct, returned] = initTrial(e, params);

% If *Train parameters are sent they are meant to override the config file.
% If they are not sent we set them to what's in the config file
e = checkOverride(e, 'signal', params);
e = checkOverride(e, 'location', params);
e = checkOverride(e, 'coherence', params);
e = checkOverride(e, 'nFramesPreMin', params);
e = checkOverride(e, 'nFramesPreMean', params);
e = checkOverride(e, 'nFramesPreMax', params);
e = checkOverride(e, 'nFramesCoh', params);
e = checkOverride(e, 'responseInterval', params);


function e = checkOverride(e, name, params)
% Get experimental parameter allowing by-trial overrides from LabView
% Overrides have the string 'Train' appended (i.e. 'foo' -> 'fooTrain').

nameTrain = [name 'Train'];
if ~isfield(params, nameTrain)
    e = setTrialParam(e, nameTrain, getParam(e, name));
end
