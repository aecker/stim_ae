function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% set randomization
params.imageStats = e.imgStatConst(params.imageStats);
r = AllImagesRandomization(params.imagePath,params.imageStats);
e = set(e,'randomization',r);

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% create alpha blend mask
win = get(e,'win');
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
location = getSessionParam(e,'location',1);
bgColor = getSessionParam(e,'bgColor',1);
diskSize = getSessionParam(e,'diskSize',1);
fadeFactor = getSessionParam(e,'fadeFactor',1);    

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

e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
