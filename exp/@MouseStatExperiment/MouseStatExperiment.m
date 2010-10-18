function e = MouseStatExperiment(varargin)

e.movie = [];
e.frameRate = [];
e.frameSize = [];
e.movieStat = {'nat','phs'};


t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'MouseStatExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
