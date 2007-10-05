function e = gaborGratingExp(varargin)
% Simple gabor patch with block randomization.

%% Copy constructor
if nargin == 1 && isa(varargin{1},'gaborGratingExp')
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
params = struct('diskSize', 100, ...                  Pixels
                'location', [0; 0], ...               Pixels (0,0) screen center
                'spatialFreq', 0.1, ...               rad/px
                'pcb1sd',10, ... for Gaussian mask 
                'direction', 0, ...                   degrees
                'speed', 10, ... (NOT IMPLEMENTED YET)                     px/sec 
                'contrast', 100, ...                  percent
                'stimTime', 2000 ...                  ms
                );
            
%% Stimulus
% -------------------------------------------------------------------------
% Some variables we need to precompute the stimulus
e.textures = [];
e.textureSize = [];
e.alphaMask = [];


%% Create class object
% -------------------------------------------------------------------------
% The second through fourth arguments are not needed as what we are passing
% are the default input values. We could also write
%     t = TrialBasedExperiment(params);
t = TrialBasedExperiment(params,'BlockRandomization',{},[]);
e = class(e,'gaborGratingExp',t);


%% Prepare experiment
% -------------------------------------------------------------------------
% This way we can simply type 'gaborGratingExp' to the command line and
% this will start the session.
if startNow
    e = openWindow(e);
    e = generateGaborTextures(e);
    e = startTcpListener(e);
end
