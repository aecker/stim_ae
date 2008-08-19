function e = initCondition(e,cond)
% Condition-specific initialization.
% PHB 2008-07-09

imageStats = {'whn','phs','nat'};

win = get(e,'win');
rect = Screen('Rect',win);

imagePath = getSessionParam(e,'imagePath',1);        % image path
n = getSessionParam(e,'imageNumber',cond);          % number of the image
stat = imageStats{getSessionParam(e,'imageStats',cond)}        % image statistics

% read image
img = imread(getLocalPath(sprintf('%s\\%05.0f_%s.tif',imagePath,n,stat)));

% generate texture
imgSize = size(img);
diskSize = getSessionParam(e,'diskSize',cond);
fadeFactor = getSessionParam(e,'fadeFactor',cond);    
dx = ceil(fadeFactor*diskSize);
texture = img(imgSize(1)/2 + (-dx+1:dx),imgSize(2)/2 + (-dx+1:dx))';
e.textures(cond) = Screen('MakeTexture',win,texture');

% generate mask
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
location = getSessionParam(e,'location',cond);
bgColor = getSessionParam(e,'bgColor',cond);

[X,Y] = meshgrid((-halfWidth:halfWidth-1) - location(1), ...
             (-halfHeight:halfHeight-1) - location(2));

alphaLum = repmat(permute(bgColor,[2 3 1]), ...
                  2*halfHeight,2*halfWidth);

% create blending map with cosine fade out
normXY = sqrt(X.^2 + Y.^2);              
disk = (normXY < diskSize/2);
blend = normXY < fadeFactor*diskSize/2 & normXY >= diskSize/2;
mv = fadeFactor*diskSize/2 - diskSize/2;
blend = (0.5*cos((normXY-diskSize/2)*pi/mv)+.5).*blend;

alphaBlend = 255 * (1-blend-disk);


e.alphaMask(cond) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
