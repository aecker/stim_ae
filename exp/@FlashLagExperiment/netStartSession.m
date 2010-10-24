function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Session initalization
% AE 2010-10-16

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% bar texture (to be able to rotate easiily)
barColor = getParam(e,'barColor');
barSize = getParam(e,'barSize');
texMat = permute(repmat(barColor,[1; barSize]),[2 3 1]);
e.tex = Screen('MakeTexture',get(e,'win'),texMat);

Screen('BlendFunction',get(e,'win'),'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');
