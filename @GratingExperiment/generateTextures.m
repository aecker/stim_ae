function e = generateTextures(e)
% Generate textures with gratings
%
% NOTE:
% In case you do something really time-consuming here, make sure to set the
% timeout in the state system appropriately. Whenever the state system
% changes parameters, we have to recompute the textures. But the state
% system is waiting for confirmation that the parameters we successfully
% set, which will timeout if this function runs too long.

win = get(e,'win');
rect = Screen('Rect',win);
params = get(e,'params');

% generate grating texture
nContrast = length(params.contrast);
nSpatFreq = length(params.spatialFreq);
for i = 1:nContrast
    for j = 1:nSpatFreq
        period = 2*pi / params.spatialFreq(j);
        e.textureSize(i,j) = ceil(max(params.diskSize) + period);
        [x,y] = meshgrid(1:e.textureSize(i,j), 1:e.textureSize(i,j));
        gratingMatrix = 127.5 + (127.5 * sin(params.spatialFreq(j) .* y) * ...
            params.contrast(i) / 100);
        e.textures(i,j) = Screen('MakeTexture',win,gratingMatrix);
    end
end

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture):
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% generate aperture
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
nBgColor = size(params.bgColor,2);
nDiskSize = length(params.diskSize);
nLocation = size(params.location,2);
for i = 1:nLocation
    [X,Y] = meshgrid((-halfWidth:halfWidth-1) - params.location(1,i), ...
                     (-halfHeight:halfHeight-1) - params.location(2,i));
    for j = 1:nBgColor
        alphaLum = repmat(permute(params.bgColor(:,j),[2 3 1]), ...
                          2*halfHeight,2*halfWidth);
        for k = 1:nDiskSize
            alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > params.diskSize(k)/2);
            e.alphaMask(i,j,k) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
        end
    end
end
