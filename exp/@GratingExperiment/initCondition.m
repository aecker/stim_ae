function e = initCondition(e,cond)
% Condition-specific initialization.
% AE 2007-12-17

win = get(e,'win');
rect = Screen('Rect',win);

% generate grating texture
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);

% generate grating texture
diskSize = getSessionParam(e,'diskSize',cond);
spatFreq = getSessionParam(e,'spatialFreq',cond);
contrast = getSessionParam(e,'contrast',cond);
period = 1 / spatFreq;
e.textureSize(cond) = ceil(max(diskSize) + period);
[x,y] = meshgrid(1:e.textureSize(cond), 1:e.textureSize(cond));
gratingMatrix = 127.5 + (127.5 * sin(2*pi*spatFreq .* y) * ...
    contrast / 100);
e.textures(cond) = Screen('MakeTexture',win,gratingMatrix);

% generate mask
location = getSessionParam(e,'location',cond);
bgColor = getSessionParam(e,'bgColor',cond);
[X,Y] = meshgrid((-halfWidth:halfWidth-1) - location(1), ...
             (-halfHeight:halfHeight-1) - location(2));

alphaLum = repmat(permute(bgColor,[2 3 1]), ...
                  2*halfHeight,2*halfWidth);

alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
e.alphaMask(i) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
