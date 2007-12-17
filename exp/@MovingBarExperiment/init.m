function e = initSession(e,params)

% initialize randomization
randomization = get(e,'randomization');
randomization = set(randomization,'numSubBlocks',params.numSubBlocks);
randomization = set(randomization,'movingTrials',params.movingTrials);
randomization = set(randomization,'mapTrials',params.mapTrials);
randomization = set(randomization,'initMapTrials',params.initMapTrials);
e = set(e,'randomization',randomization);

% call parent's init function
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment);

% bar texture (to be able to rotate easiily)
texMat = permute(repmat(getParam(e,'barColor'),[1; getParam(e,'barSize')]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
