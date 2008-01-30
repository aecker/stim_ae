function e = initSession(e,params,expType)

% Create randomization
%   This has to be done before calling initSession of the parent experiment
%   since the randomization is initialized there. This way, we can use the
%   values set by labview to make a randomization object.
rnd = MovingBarRandomization(params.numSubBlocks,params.movingTrials, ...
                             params.initMapTrials,params.mapTrials);
e = set(e,'randomization',rnd);

% call parent's init function
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% bar texture (to be able to rotate easiily)
barColor = getSessionParam(e,'barColor',1);
barSize = getSessionParam(e,'barSize',1);
texMat = permute(repmat(barColor,[1; barSize]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
