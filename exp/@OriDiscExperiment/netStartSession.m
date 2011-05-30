function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Session initialization
% AE 2010-10-24

% compute response target locations 
%   +90 because grating is along the y axis
%   centered relative to the stimulus
left = params.centerOrientation - params.targetAngle + 90;
right = params.centerOrientation + params.targetAngle + 90;
R = @(phi) [sin(phi / 180 * pi); -cos(phi / 180 * pi)];
params.leftTarget = params.location + R(left) * params.targetDistance;
params.rightTarget = params.location + R(right) * params.targetDistance;

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% screen size
win = get(e,'win');
rect = Screen('Rect',win);

% generate grating texture
diskSize = getSessionParam(e,'diskSize'); % pixels
spatFreq = getSessionParam(e,'spatialFreq'); % cycles/pixel
contrast = getSessionParam(e,'contrast');
period = 1 / spatFreq;
e.textureSize = ceil(diskSize + period);
y = repmat((1:e.textureSize)',1,e.textureSize);
grating = 127.5 + (127.5 * sin(2*pi*spatFreq .* y) * contrast / 100);
e.texture = Screen('MakeTexture',win,grating);

% generate mask
location = getSessionParam(e,'location');
monitorCenter = getSessionParam(e,'monitorCenter');
bgColor = getSessionParam(e,'bgColor');
x = (rect(1):rect(3)) - monitorCenter(1) - location(1);
y = (rect(2):rect(4)) - monitorCenter(2) - location(2);
[X,Y] = meshgrid(x,y);
alphaLum = repmat(permute(bgColor,[2 3 1]),[size(X) 1]);
alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize / 2);
e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));

% enable alpha blending
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
