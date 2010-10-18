function e = MouseMovieExperiment(varargin)

e.movie = [];
e.alphaMask = [];
e.frameRate = [];
e.frameSize = [];
e.movieLength = [];


t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'MouseMovieExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
