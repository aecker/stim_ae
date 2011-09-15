function [e,retInt32,retStruct,returned] = netStartSession(e,params)


% compute response target locations 
%   +90 because grating is along the y axis
%   centered relative to the stimulus

left = params.centerOrientation - params.targetAngle + 90;
right = params.centerOrientation + params.targetAngle + 90;
R = @(phi) [sin(phi / 180 * pi); -cos(phi / 180 * pi)];
params.leftTarget = params.stimulusLocation + R(left) * params.targetDistance;
params.rightTarget = params.stimulusLocation + R(right) * params.targetDistance;
% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% generate grating texture
pxPerDeg = getPxPerDeg(getConverter(e));
spatFreq = params.spatialFreq / pxPerDeg(1);
period = 1 / spatFreq;

% texture needs to be a bit larger because we're going to move it under the
% aperture to generate different phases
e.textureSize = ceil(params.diskSize + period);

% rotate coordinate system
phi = 2*pi*spatFreq * (1:e.textureSize);
grat = 0.5 + 0.5 * params.contrast * sin(phi);

% color grating
color = permute(params.color,[2 3 1]);
grat = bsxfun(@times,color,grat);

% create texture
e.texture = Screen('MakeTexture',get(e,'win'),grat,[],[],1);

% generate alpha mask
win = get(e,'win');
rect = Screen('Rect',win);
hw = ceil(diff(rect([1 3])) / 2);
hh = ceil(diff(rect([2 4])) / 2);
loc = params.stimulusLocation;
[X,Y] = meshgrid(-hw:hw-1,-hh:hh-1);
alphaLum = repmat(permute(params.bgColor,[2 3 1]),2*hh,2*hw);
if params.isMask % smooth edges?
    % radial cosine window
    d = sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) / params.diskSize;
    alphaBlend = (1 - cos(d * 2 * pi)) / 2;
%     % exponential (i.e. Gabor)
%     d = sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) / (params.diskSize / 5);
%     alphaBlend = 1 - exp(-d.^2);
else
    alphaBlend = zeros(size(X));
end
outside = sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) > params.diskSize / 2;
alphaBlend(outside) = 1;
e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend),[],[],1);
