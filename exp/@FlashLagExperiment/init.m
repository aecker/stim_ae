function e = init(e)
% Initalization
% AE 2007-02-21

params = get(e,'params');
params.trials.swapTimes = [];
params.trials.barLocations = [];
e = set(e,'params',params);

% call parent's init function
e.TrialBasedExperiment = init(e.TrialBasedExperiment);

% bar texture (to be able to rotate easiily)
texMat = permute(repmat(getParam(e,'barColor'),[1; getParam(e,'barSize')]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
