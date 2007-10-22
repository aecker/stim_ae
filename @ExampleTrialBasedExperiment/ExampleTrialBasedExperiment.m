function e = ExampleTrialBasedExperiment(varargin)
% Simple solid color rectangular stimului with block randomization.

%% Copy constructor
if nargin == 1 && isa(varargin{1},'ExampleTrialBasedExperiment')
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

%startNow=false;

%% Parameters
% -------------------------------------------------------------------------
% * These parameters are all set by the state system during <startSession>.
% * We put some default values in order to be able to debug without using
%   the state system.
% * Vector-valued parameters are column vectors, i.e. one column per
%   possible value of the given parameter.
params = struct();


%% Photodiode timer
% -------------------------------------------------------------------------
% * The PhotoDiodeTimer draws a small spot with alternating color at the corner
%   of the display which is recorded by a photodiode to do precise timing.
% * It also swaps the buffers and keeps a high-precision timestamp of the
%   buffer swap using the PTB.
e.photoDiodeTimer = PhotoDiodeTimer;

%% Create class object
% -------------------------------------------------------------------------
% The second through fourth arguments are not needed as what we are passing
% are the default input values. We could also write
%     t = TrialBasedExperiment(params);
fields.swapTimes = [];
fields.difficulty = 1;
fields.stimulus = 1;
fields.trialDirection = 400;

t = TrialBasedExperiment(null, null);
e = class(e,'ExampleTrialBasedExperiment',t);

%% Prepare experiment
% -------------------------------------------------------------------------
% This way we can simply type 'leverPressExp' to the command line and
% this will start the session.
if startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
