function e = init(e,params)
% Initalization
% AE 2007-11-12

% call parent's init function
e.TrialBasedExperiment = init(e.TrialBasedExperiment,params);

% bar texture (to be able to rotate easiily)
texMat = permute(repmat(getParam(e,'barColor'),[1; getParam(e,'barSize')]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
