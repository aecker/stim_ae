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

% make sure we have all parameters set
assertCorrectParams(e);
e.params.constants.expType = class(e);
e.params.trials.validTrial = true;
e.params.trials.correctResponse = true;

% get event types and sites
[eventTypes,eventSites] = getEventTypes(e);

% initalize sounds
basePath = fileparts(mfilename('fullpath'));
soundFiles = getSoundFiles(e);
f = fieldnames(soundFiles);
for i = 1:length(f)
    fileName = fullfile(basePath,'sounds',[soundFiles.(f{i}),'.wav']);
    e.soundWaves.(f{i}) = wavread(fileName); % read sound file
    eventTypes{end+1} = [f{i} 'Sound'];      % add sound event
    eventSites(end+1) = 0;
end

% initialize randomization
e.randomization = init(e.randomization,e.params.conditions);

% initialize stimulation data container
conditions = getConditions(e.randomization);
e.data = init(e.data,e.params.constants,conditions,e.params.trials, ...
                     eventTypes,eventSites);

% save parameters to disk
saveData(e.data);
