function e = TrialBasedExperiment(varargin)
% Simple grating experiment with block randomization.

%% Copy constructor
if nargin == 1 && isa(varargin{1},'TrialBasedExperiment')
    e = varargin{1};
    return
end


%% Parameters
% -------------------------------------------------------------------------
% * This is a structure containing default values in order to be able to
%   run a test without having to set all parameters by hand every time.
e.params = struct('bgColor', [127.5; 127.5; 127.5], ... [R,G,B] 
                  'fixSpotColor', [255; 0; 0], ...      [R,G,B]
                  'fixSpotSize', 10, ...                [R,G,B]
                  'fixSpotLocation', [0; 0], ...        [R,G,B]
                  'fixWinSize', 50, ...                 px
                  'fixAcquireTime', 1500, ...           ms
                  'fixHoldTime', 300, ...               .
                  'interTrialTime', 1500, ...           . 
                  'rewardProb', 0.8, ...                probability
                  'juiceTime', 50, ...                  ms
                  'numTrials', 5 ...                   trials 
                  );

% Append parameters if passed
if nargin > 0
    params = varargin{1};
    paramNames = fieldnames(params);
    for i = 1:length(paramNames)
        e.params.(paramNames{i}) = params.(paramNames{i});
    end
end

% determine structure of parameters
paramNames = fieldnames(e.params);
for i = 1:length(paramNames)
    e.paramSizes.(paramNames{i}) = size(e.params.(paramNames{i}),1);
end

% here we are going to store the parameters for the current trial during
% the session.
e.curParams = struct;
e.curIndex = struct;


%% Randomization
% -------------------------------------------------------------------------
% The randomization is performed by a separate object. This randomization
% object R has to provide the following functions:
% * [R,indices] = getNextTrial(R)
%     indices is a set of indices (one for each parameter) specifying
%     which value of each parameter to use in the current trial.
% * R = trialCompleted(R,success)
%     success is true if the current trial has been successfully completed.
% -------------------------------------------------------------------------

% Default input value
if nargin < 2
    randomization = 'BlockRandomization';
else
    randomization = varargin{2};
end

% Get parameters and determine number of possible values
% * Every time the number of values change for some parameters, we need to
%   re-initialize the randomization object.
paramNames = fieldnames(e.params);
n = length(paramNames);
numValues = zeros(1,n);
for i = 1:n
    numValues(i) = size(e.params.(paramNames{i}),2);
end

% Create randomization object
e.randomization = feval(randomization, numValues, e.params.numTrials);


%% Sounds
% * We start off with these four default sounds
% * If someone wnats different sounds, he can pass a structure in the form
%     sounds.soundName1 = 'file1'
%     sounds.soundName2 = 'file2' ...
e.soundFiles.startTrial = 'startTrialDefault';
e.soundFiles.eyeAbort = 'eyeAbortDefault';
e.soundFiles.leverAbort = 'leverAbortDefault';
e.soundFiles.reward = 'rewardDefault';
if nargin > 4
    s = varargin{5};
    f = fieldnames(s);
    for i = 1:length(f)
        e.soundFiles.(f{i}) = s.(f{i});
    end
end
e.soundWaves = struct;


%% Events
% -------------------------------------------------------------------------
% * If third and fourth argument is passed, this is a custom set of event 
%   names which we append to the predefined ones.
eventNames = {'startTrial'; ...
              'showFixSpot'; ...
              'acquireFixation'; ...
              'showStimulus'; ...
              'response'; ...
              'startReward'; ...
              'endReward'; ...
              'eyeAbort'; ...
              'leverAbort'; ...
              'clearScreen'};      
if nargin > 2
    eventNames = cat(1,eventNames,varargin{3}{:});
end

% Event sites (local/remote)
% * The second column specifies whether timestamps for the given event are
%   taken locally or at the state system (0 = local, 1 = remote).
% * For aborts, we store the local timestamp when the stimulus was removed.
eventSites = [0 0 1 0 1 1 1 1 1 0];
if nargin > 3
    eventSites = [eventSites, varargin{4}];
end

% since sounds create events that get timestamped, we have to add the
% corresponding events to the list
f = fieldnames(e.soundFiles);
for i = 1:length(f)
    eventNames{end+1} = [f{i} 'Sound'];
end
eventSites = [eventSites, zeros(1,length(f))];


%% Data storage
% ------------------------------------------------------------------------------
% In this structure we store all trial data (currently condition index and
% events) that will be saved to disk at the end of the session.
if nargin > 5
    extraFields = varargin{6};
end
extraFields.correctResponse = false;
e.data = StimulationData(eventNames,eventSites,extraFields);


%% Create class object
e = class(e,'TrialBasedExperiment',BasicExperiment);


%% initialize sounds
e = initSounds(e);

