function e = MovingBarExperiment(varargin)
% Simple moving bar experiment
% AE & PhB 2007-09-28

%% Copy constructor
if nargin == 1 && isa(varargin{1},'MovingBarExperiment')
    e = varargin{1};
    return
end

% otherwise 1st input argument indicates whether to prepare the experiment
% immediately (default) (i.e. open window, start tcp listener etc...)
if nargin == 1
    startNow = varargin{1};
else
    startNow = true;
end


%% Parameters
% -------------------------------------------------------------------------
% * These parameters are all set by the state system during <startSession>.
% * We put some default values in order to be able to debug without using
%   the state system.
% * Vector-valued parameters are column vectors, i.e. one column per
%   possible value of the given parameter.
params = struct('barSize', [10; 1000] ...          (width; height) pixels
                'barColor', [255; 255; 255], ...
                'speed', 500, ...                  pixels/sec
                'trajectoryStart', [100; 600], ... (x,y) from top left corner; center of box
                'trajectoryLength', 1000, ...      pixels
                'trajectoryAngle', 0, ...          degrees (to be implemented)
                'initMapTrials', 100, ...          initial rf mapping (at beginning of experiment only)
                'mapLocPerTrial', 30, ...          random locations per mapping trial
                'mapFramesPerLoc', 3, ...          frames per location
                'mapTrials', 15, ...               mapping trials at end of each moving block
%                 'reversalTrials', 10, ...          trials where movement reverses
%                 'reversalLocation', 0.5, ...       % of total trajectory length where reversal occurs
                'movingTrials', 85, ...            trials with normal movement
                'blocksPerPrior', 3, ...           
                'priors', [0.5 0.1 0.9], ...       fraction of rightwards movement
                );


%% Stimulus
% -------------------------------------------------------------------------
% Some variables we need to precompute the stimulus


%% Create class object
% -------------------------------------------------------------------------
% The second through fourth arguments are not needed as what we are passing
% are the default input values. We could also write
%     t = TrialBasedExperiment(params);
t = TrialBasedExperiment(params,'BlockRandomization',{},[]);
e = class(e,'MovingBarExperiment',t);


%% Prepare experiment
% -------------------------------------------------------------------------
% This way we can simply type 'GratingExperiment' to the command line and
% this will start the session.
if startNow
    e = openWindow(e);
%     e = generateTextures(e);
    e = startTcpListener(e);
end
