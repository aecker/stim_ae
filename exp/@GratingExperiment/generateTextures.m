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

r = get(e,'randomization');
conditions = getConditions(r);


% generate grating texture

halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
for i=1:length(conditions)
        % generate grating texture
        currSpatFreq = conditions(i).spatialFreq;
        currContrast = conditions(i).contrast;
        period = 1 / currSpatFreq;
        e.textureSize(i) = ceil(max(diskSize) + period);
        [x,y] = meshgrid(1:e.textureSize(i), 1:e.textureSize(i));
        gratingMatrix = 127.5 + (127.5 * sin(2*pi*currSpatFreq .* y) * ...
            currContrast / 100);
        e.textures(i) = Screen('MakeTexture',win,gratingMatrix);
        
        % generate mask
        currLocation = conditions(i).location;
        currBgColor = conditions(i).bgColor;
        currDiskSize = conditions(i).diskSize;
        
        [X,Y] = meshgrid((-halfWidth:halfWidth-1) - currLocation(1), ...
                     (-halfHeight:halfHeight-1) - currLocation(2));
       
        alphaLum = repmat(permute(currBgColor,[2 3 1]), ...
                          2*halfHeight,2*halfWidth);
 
        alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > currDiskSize/2);
        e.alphaMask(i) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
 end

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture):
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

