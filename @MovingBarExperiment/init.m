function e = init(e)
% Initalization
% AE 2007-02-21

params = get(e,'params');
params.trials.swapTimes = [];
params.trials.barLocations = [];
e = set(e,'params',params);

randomization = get(e,'randomization');
randomization = set(randomization,'numSubBlocks',params.constants.numSubBlocks);
randomization = set(randomization,'movingTrials',params.constants.movingTrials);
randomization = set(randomization,'mapTrials',params.constants.mapTrials);
randomization = set(randomization,'initMapTrials',params.constants.initMapTrials);
e = set(e,'randomization',randomization);

% call parent's init function
e.TrialBasedExperiment = init(e.TrialBasedExperiment);

% bar texture (to be able to rotate easiily)
texMat = permute(repmat(getParam(e,'barColor'),[1; getParam(e,'barSize')]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
