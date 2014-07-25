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
scFactor = params.imSize; 

nFirst = params.firstTexNumber; %first texture to pick from texture struc.
nLast = nFirst + nIm * nGS - 1; %last texture to pick from texture struc.
params.lastTexNumber = nLast;


%load texture structure

file=sprintf('/Volumes/lab/users/leon/leon_textures/NatImTextures_%d.mat',nTex);
f = load(file);
params.sourcefile = sprintf('NatImTextures_%d.mat',nTex); 

%create textures
e.textures = zeros(3,nGS*nIm);
sm = ones(scFactor); %for scaling the pixels by scFactor
for i = 1:(nLast - nFirst + 1)
    j = i + nFirst - 1;
    params.source{i} = f.textures(j).source.name;
    e.textures(1,i)= Screen('MakeTexture',win,kron(double(f.textures(j).nat),sm)); 
    e.textures(2,i)= Screen('MakeTexture',win,kron(double(f.textures(j).phs),sm));
    e.textures(3,i)= Screen('MakeTexture',win,kron(double(f.textures(j).whn),sm));
   % e.textures(4,i)= Screen('MakeTexture',win,kron(double(f.textures(j).org),sm));
end


% define stimulus position
e.textureSize = scFactor*size(f.textures(nFirst).nat,1);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);
e.destRect = [-e.textureSize -e.textureSize e.textureSize e.textureSize] / 2 ...
        + [centerX centerY centerX centerY];
    

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);
