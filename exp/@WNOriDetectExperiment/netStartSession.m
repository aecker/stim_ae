function [e, retInt32, retStruct, returned] = netStartSession(e, params)
% Start session.
% AE 2012-11-27

% draw random seeds
rand('state', now * 1000);                                             %#ok
params.seeds = ceil(rand(1, params.nSeeds) * 1e6);

% initialize parent
[e, retInt32, retStruct, returned] = initSession(e, params);

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e, 'win');
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% generate grating texture
pxPerDeg = getPxPerDeg(getConverter(e));
spatFreq = params.spatialFreq / pxPerDeg(1);
period = 1 / spatFreq;

% texture needs to be a bit larger because we're going to move it under the
% aperture to generate different phases
e.textureSize = ceil(params.diskSize + period);

% rotate coordinate system
phi = 2 * pi * spatFreq * (1 : e.textureSize);
grat = 127.5 + 127.5 * params.contrast * sin(phi);

% color grating
color = permute(params.color, [2 3 1]);
grat = bsxfun(@times, color, grat);

% create texture
e.texture = Screen('MakeTexture', win, grat);

% generate alpha mask
rect = Screen('Rect', win);
loc = params.stimulusLocation;
[X, Y] = meshgrid((0 : rect(3) - 1) - params.monitorCenter(1), ...
                  (0 : rect(4) - 1) - params.monitorCenter(2));
alphaLum = repmat(permute(params.bgColor, [2 3 1]), rect(4), rect(3));
if params.isMask % smooth edges?
    d = sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) / params.diskSize;
    alphaBlend = (1 - cos(d * 2 * pi)) / 2; % radial cosine window
else
    alphaBlend = zeros(size(X));
end
outside = sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) > params.diskSize / 2;
alphaBlend(outside) = 1;
e.alphaMask = Screen('MakeTexture', win, cat(3, alphaLum, 255 * alphaBlend));
