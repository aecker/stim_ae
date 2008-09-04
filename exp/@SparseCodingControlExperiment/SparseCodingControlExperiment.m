function e = SparseCodingControlExperiment(varargin)
% Sparse Coding Experiment with block randomization.
% In each session, N images are selected from a database. 


% Some variables we need to precompute the stimulus
e.currTex = [];
e.alphaMask = [];
e.imgStatConst = {'whn','phs','nat'};

t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'SparseCodingControlExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
