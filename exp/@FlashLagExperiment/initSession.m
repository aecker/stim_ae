function e = initSession(e,params,expType)
% Initalization
% AE 2007-11-12

% call parent's init function
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% bar texture (to be able to rotate easiily)
barColor = getSessionParam(e,'barColor',1);
barSize = getSessionParam(e,'barSize',1);
texMat = permute(repmat(barColor,[1; barSize]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);
