function e = TrialBasedExperiment(arg1,eventNames,eventSites,soundFiles)
% Simple grating experiment with block randomization.

%% Copy constructor
if nargin == 1 && isa(arg1,'TrialBasedExperiment')
    e = arg1;
    return
end


%% Parameters
e.params = struct;
e.paramTypes = struct;


%% Randomization
% -------------------------------------------------------------------------
% The randomization is performed by a separate object. This randomization
% object R has to provide the following functions:
% * [R,indices] = getNextTrial(R)
%     indices is a set of indices (one for each parameter) specifying
%     which value of each parameter to use in the current trial.
% * R = trialCompleted(R,valid,correct)
%     valid is true if the current trial has been successfully completed.
%     correct is true if they got the right answer.
% -------------------------------------------------------------------------
if ~exist('arg1','var')
    e.randomization = BlockRandomization;
else
    e.randomization = arg1;
end


%% Sounds
e.soundFiles.startTrial = 'startTrialDefault';
e.soundFiles.eyeAbort = 'eyeAbortDefault';
e.soundFiles.leverAbort = 'leverAbortDefault';
e.soundFiles.reward = 'rewardDefault';
e.soundFiles.prematureAbort = 'prematureAbortDefault';
e.soundFiles.correctResponse = 'correctResponse';
e.soundFiles.incorrectResponse = 'incorrectResponse';
if exist('soundFiles','var')
    f = fieldnames(soundFiles);
    for i = 1:length(f)
        e.soundFiles.(f{i}) = soundFiles.(f{i});
    end
end
e.soundWaves = struct;


%% Events
if exist('eventNames','var') && ...
        (~exist('eventSites','var') || length(eventNames) ~= length(eventSites))
    error('TrialBasedExperiment:TrialBasedExperiment', ...
          'Event names and sites don''t match!');
end

if ~exist('eventNames','var'), eventNames = {}; end
eventNames = [eventNames; {'startTrial'; ...
                           'showFixSpot'; ...
                           'acquireFixation'; ...
                           'showStimulus'; ...
                           'response'; ...
                           'startReward'; ...
                           'endReward'; ...
                           'eyeAbort'; ...
                           'leverAbort'; ...
                           'prematureAbort'; ...
                           'clearScreen'}];      

% Event sites (local/remote)
if ~exist('eventSites','var'), eventSites = []; end
eventSites = [eventSites 0 0 1 0 1 1 1 1 1 0];

% since sounds create events that get timestamped, we have to add the
% corresponding events to the list
f = fieldnames(e.soundFiles);
for i = 1:length(f)
    eventNames{end+1} = [f{i} 'Sound'];
end
eventSites = [eventSites, zeros(1,length(f))];


%% Data storage
e.data = StimulationData(eventNames,eventSites);


%% Create class object
e = class(e,'TrialBasedExperiment',BasicExperiment);

