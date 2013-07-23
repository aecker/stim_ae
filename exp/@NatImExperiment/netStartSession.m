function [e,retInt32,retStruct,returned] = netStartSession(e,params)




% create alpha blend mask
win = get(e,'win');
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
location = params.stimulusLocation;
bgColor = params.bgColor;
diskSize = params.diskSize;
fadeFactor = params.fadeFactor;    

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

nTex = params.texFileNumber; %no. of texture structure
nIm = params.imPerTrial; % images per trial
nGS = params.seqGroupsPerSession;%no. of distinct sequence Groups per session (each group has 3 sequences)

nFirst = params.firstTexNumber; %first texture to pick from texture struc.
nLast = nFirst+nIm*nGS*3; %last texture to pick from texture struc.


%load texture structure
%texFile = params.texFile;
%load(getLocalPath(texFile));
%load(getLocalPath('Users/atlab/Desktop/leon_textures/textures1.mat'));
file=sprintf('/Volumes/lab/users/george/leon_textures/LPtextures_%d.mat',nTex);
%file = sprintf('/Volumes/scratch01/leon_textures/LPtextures_%d.mat',n);
load(file)

params.source={textures(nFirst:nLast).source};


%create textures
e.textures = zeros(3,nGS*nIm);
scFactor = 3;
sm = ones(scFactor); %for scaling the pixels by scFactor
for i = nFirst:nLast
    e.textures(1,i-(nFirst-1))= Screen('MakeTexture',win,kron(double(textures(i).nat),sm)); 
    e.textures(2,i-(nFirst-1))= Screen('MakeTexture',win,kron(double(textures(i).phs),sm));
    e.textures(3,i-(nFirst-1))= Screen('MakeTexture',win,kron(double(textures(i).whn),sm));
end


% define stimulus position
e.textureSize = scFactor*size(textures(nFirst).nat,1);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);
e.destRect = [-e.textureSize -e.textureSize e.textureSize e.textureSize] / 2 ...
        + [centerX centerY centerX centerY];
    

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);
