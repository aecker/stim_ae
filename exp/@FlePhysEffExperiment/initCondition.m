function e = initCondition(e,cond)
% Condition-specific initialization.
% AE 2008-09-03

% bar textures (to be able to rotate easiily)
barColor = getSessionParam(e,'barColor',cond);
texMat = permute(barColor,[2 3 1]);
e.tex(cond) = Screen('MakeTexture',get(e,'win'),texMat);
