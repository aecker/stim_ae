function e = MovingBarExperiment
% Simple moving bar experiment
% AE & PhB 2007-09-28

% bar texture(s)
e.tex = [];

% Create class object
%   Randomization needs to know some parameters we don't know until
%   netStartSession, so we create it there.
t = TrialBasedExperiment([],StimulationData);
e = class(e,'MovingBarExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end

