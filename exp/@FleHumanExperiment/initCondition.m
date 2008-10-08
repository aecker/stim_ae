function e = initCondition(e,cond)
% Initialize condition
% AE 2008-10-08

% bar texture (to be able to rotate easiily)
barColor = getSessionParam(e,'barColor',cond);
barSize = getSessionParam(e,'barSize',cond);
texMat = permute(repmat(barColor,[1; barSize]),[2 3 1]);
e.tex(cond) = Screen('MakeTexture',get(e,'win'),texMat);
