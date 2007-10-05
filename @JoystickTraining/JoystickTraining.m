function e = JoystickTraining(varargin)
% Simple solid color rectangular stimului with block randomization.

%% Copy constructor
if nargin == 1 && isa(varargin{1},'JoystickTraining')
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
params = struct( ... Common parameters
                'location', [0; 0], ...   pixels relative to screen center
                'stimTime', 2000, ...     ms
                'answer', 'color', ...    correct answer is based on this property
                'randomization', 'BlockNonrandom', ...  the default randomization schedule
                ... animal makes a response the stimulus will disappear and
                ... otherwise it will stay for the whole stimulus period
                ...
                ...  For Red/Green
                'color',[[100; 200; 0], [0; 0; 0]], ...  [r;g;b]
                'size', [400; 400], ...                  pixels
                ...  For Gabor filter 
                'diskSize', 200, ...                  Pixels
                'spatialFreq', 0.1, ...               rad/px
                'pcb1sd',10, ...                      for Gaussian mask (based on cycles) 
                'pcbsize',1000, ...                   for Guassian mask (based on pixel)
                'contrast', 100, ...                
                ...  For Coherent dots
                'coherence', 60, ...                  rad/px
                'dotSize', .05, ...                   degrees
                'numDots', 2000, ...
                'fkill', 0, ...                       fraction to kill
                'annulus', 5, ...
                ...  For Coherent dots and Gabor filter
                'direction', 0, ...                   degrees
                'speed', 10, ...                      px/sec 
				... For displaying images
				'imageClass', 'm', ...				  prefixes for image files
				'imageNum', 1, ...					  number of images in each class
				... for now this last parameter is going to be a single integer to 
				... make the randomization code not have to worry about it.  this 
				... has the disadvantage that all images classes must have the same
				... number of elements which wont be the case with only a few ambiguous 
				... stimuli.  However this will require seperate labview/matlab code
                'staircaseStep', .1, ...               the step size for staircase
                'stepCount', 3, ...                    how many right till step
                ... For distributions of correct choices
                'distributionA', '.1/length(theta)+.9*exp(10*(cos(2*pi*(theta-90)/360)-1))/sum(exp(10*(cos(2*pi*(theta-90)/360)-1)))', ...
                'distributionB', '.1/length(theta)+.9*exp(3*(cos(2*pi*(theta-270)/270)-1))/sum(exp(3*(cos(2*pi*(theta-270)/360)-1)))', ...
                'targetAColor', [255;0;0], ...
                'targetBColor', [0;255;0], ...   
                'incorrectIntensity', .92, ...  % the percentage of full intensity to show the wrong choice
                ... For having to match class to dot
                'targetOffset', 300, ...        % from center
                'targetSetup', [1,2,3,4], ...   %1 means A is answer and on 
                ...                                %left, 2 means B is answer
                ...                                %and on right, 3 means B is
                ...                                %answer and on left, 4
                ...                                %means A is answer and on
                ...                                %right
                'targetDiameter', 50 ...
                );


%% Photodiode timer
% -------------------------------------------------------------------------
% * The PhotoDiodeTimer draws a small spot with alternating color at the corner
%   of the display which is recorded by a photodiode to do precise timing.
% * It also swaps the buffers and keeps a high-precision timestamp of the
%   buffer swap using the PTB.
e.photoDiodeTimer = PhotoDiodeTimer;

% This is used to doing staircase psychophysical thresholding
e.correctSinceAdjust = 0;
e.currentDifficulty = 1;

% Some variables we need for Gabor filteres
e.textures = [];
e.textureSize = [];
e.alphaMask = [];

e.images = {};

%% Create class object
% -------------------------------------------------------------------------
% The second through fourth arguments are not needed as what we are passing
% are the default input values. We could also write
%     t = TrialBasedExperiment(params);
fields.swapTimes = [];
fields.difficulty = 1;
fields.stimulus = 1;
fields.trialDirection = 400;

 t = TrialBasedExperiment(params,'BlockNonrandom',{},[],struct,fields);
% t = TrialBasedExperiment(params,'TrainingBalancePerformanceRandomization',{},[],struct,fields);
% t = TrialBasedExperiment(params,'TrainingBalanceRandomization',{},[],struct,fields);
%t = TrialBasedExperiment(params,'BlockNonrandom',{},[],struct,fields);
% t = TrialBasedExperiment(params,'BlockRandomization',{},[],struct,fields);
e = class(e,'JoystickTraining',t);


%% Prepare experiment
% -------------------------------------------------------------------------
% This way we can simply type 'leverPressExp' to the command line and
% this will start the session.
if startNow
    e = openWindow(e);
    e = startTcpListener(e);
end
