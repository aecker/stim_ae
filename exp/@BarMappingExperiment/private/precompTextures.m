function [e,tex] = precompTextures(e)
% Precompute bar textures.
% We use textures rather than drawRect in order to be able to easily rotate
% them.
%
% AE & MS 2008-07-17

barColor  = getParam(e,'barColor');
barLength = getParam(e,'barLength');
barWidth  = getParam(e,'barWidth');
nColors = size(barColor,2);
e.tex = zeros(nColors);
for i = 1:nColors
    texMat = zeros([barLength,barWidth,3]) + barColor(i);
    e.tex(i) = Screen('MakeTexture',get(e,'win'),texMat);
end
if nargout > 1
    tex = e.tex;
end
