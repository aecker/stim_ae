function [e,retInt32,retStruct,returned] = netInitTrial(e,params)
% Trial initialization.
%   This function can be overridden to perform time-consuming initialization 
%   code during intertrial. Whether you override this function of netStartTrial
%   will affect the actual amount of time between two stimuli. Since all 
%   function calls from LabView (except netShowStimulus) are blocking by
%   default, any time spent in netStartTrial will add to the intertrial time,
%   since its counter starts after netStartTrial returns. In contrast,
%   netInitTrial is run during intertrial, meaning that time spent here won't
%   extend the intertrial time (provided the function doesn't take longer than
%   intertrialTime ms).
%
% AE 2009-03-16

tic
% make stimulus
win = get(e,'win');
rect = Screen('Rect',win);
cond = getParam(e,'condition');

n = getSessionParam(e,'imageNumber',cond);          % number of the image
n = find(e.textureNum == n);
stat = e.imgStatConst{getSessionParam(e,'imageStats',cond)};

% read image
img = e.textureFile(n).(stat); %#ok<FNDSB>
e.curTexSz = size(img)';  

% generate texture
e.curTex = Screen('MakeTexture',win,img');

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
diskSize = getSessionParam(e,'diskSize',cond);
fadeFactor = getSessionParam(e,'fadeFactor',cond);    
normXY = sqrt(X.^2 + Y.^2);              
disk = (normXY < diskSize/2);
blend = normXY < fadeFactor*diskSize/2 & normXY >= diskSize/2;
mv = fadeFactor*diskSize/2 - diskSize/2;
blend = (0.5*cos((normXY-diskSize/2)*pi/mv)+.5).*blend;

alphaBlend = 255 * (1-blend-disk);


e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));

disp(toc)

retInt32 = int32(0);
retStruct = struct;
returned = false;
