function e = AllImagesExperiment(varargin)
% Sparse Coding Experiment which shows all images.


% Some variables we need to precompute the stimulus
e.curTex = [];
e.textureFile = struct;
e.textureNum = [];
e.curTexSz = [];
e.alphaMask = [];
e.imgStatConst = {'whn','phs','nat'};

t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'AllImagesExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
