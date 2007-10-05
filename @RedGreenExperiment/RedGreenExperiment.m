function e = RedGreenExperiment(varargin)
% Simple solid color rectangular stimului with block randomization.

%% Copy constructor
if nargin == 1 && isa(varargin{1},'RedGreenExperiment')
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
params = struct('color',[[100; 200; 0], [0; 0; 0]], ...  [r;g;b]
                'size', [400; 400], ...                  pixels
                'location', [0; 0], ...   pixels relative to screen center
                'stimTime', 2000 ...      ms
);


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
t = TrialBasedExperiment(params,'DontCareRandomization',{},[],struct,fields);
e = class(e,'RedGreenExperiment',t);


%% Prepare experiment
% -------------------------------------------------------------------------
% This way we can simply type 'leverPressExp' to the command line and
% this will start the session.
if startNow
    e = openWindow(e);
    e = startTcpListener(e);
end
