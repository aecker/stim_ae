function e = initCondition(e,cond)
% Condition-specific initialization.
% AE 2008-09-03

% bar textures (to be able to rotate easiily)
barColor = getSessionParam(e,'barColor',cond);
barSize = getSessionParam(e,'barSize',cond);
texMat = permute(repmat(barColor,[1; barSize]),[2 3 1]);
e.tex(cond) = Screen('MakeTexture',get(e,'win'),texMat);
