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
e.soundWaves = struct;


%% Data storage
e.data = StimulationData(eventNames,eventSites);


%% Create class object
e = class(e,'TrialBasedExperiment',BasicExperiment);

