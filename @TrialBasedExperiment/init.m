function e = init(e)
% Initialize experiment.
%    This function can be used to initialize the experiment, i.e. perform time
%    consuming operations such as precomputing textures.
%
%    When overwriting this function in derived experiment types, make sure that
%    the parent function (i.e. this one) is also called:
%        derivedExp = init(derivedExp.TrialBasedExperiment)
%
% AE 2007-10-05

% initalize sounds
basePath = fileparts(mfilename('fullpath'));
soundFiles = getSoundFiles(e);
f = fieldnames(soundFiles);
for i = 1:length(f)
    fileName = fullfile(basePath,'sounds',[soundFiles.(f{i}),'.wav']);
    e.soundWaves.(f{i}) = wavread(fileName);
end

% extract different parameter types and initialize StimulationData
const = (e.paramTypes == getParamTypeConstant(e,'constant'));
constParams = parseVarArgs(e.paramNames(const),'expType',class(e));
trials = (e.paramTypes == getParamTypeConstant(e,'trial'));
trialParams = e.paramNames(trials);
conditionParams = getConditions(e.randomization);

% get event types and sites
[eventTypes,eventSites] = getEventTypes(e);

% Construct stimulation data container
e.data = StimulationData(constParams,conditionParams,trialParams, ...
                         eventTypes,eventSites);

% save parameters to disk
saveData(e.data);
