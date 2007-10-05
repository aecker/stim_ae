function e = BasicExperiment(varargin)
% Constructor

if nargin == 1 && isa(varargin{1},'BasicExperiment')
    e = varargin{1};
    return
end

% PTB window handle
e.win = [];
e.oldVisualDebugLevel = Screen('Preference','VisualDebugLevel');
e.oldSupressAllWarnings = Screen('Preference','SuppressAllWarnings');

% tcp connection
e.tcpConnection = TcpConnection;

% buffer that stores the clock synchronization timestamps
e.sync.start = -Inf;    % first timestamp on MAC side
e.sync.response = 0;    % response by LabView state system
e.sync.end = 0;         % second timestamo on MAC side

% Maximum allowed round trip time
e.maxRoundTripTime = 10; % ms

% create object
e = class(e,'BasicExperiment');
