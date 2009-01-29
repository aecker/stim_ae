function e = initCondition(e,cond)
% Condition-specific initialization.
% AE 2007-12-17

% generate grating texture
diskSize = getSessionParam(e,'diskSize',cond);
spatFreq = getSessionParam(e,'spatialFreq',cond);
contrast = getSessionParam(e,'contrast',cond);
phase    = getSessionParam(e,'initialPhase',cond);
ori      = getSessionParam(e,'orientation',cond) / 180 * pi;
color    = getSessionParam(e,'color',cond);
period = 1 / spatFreq;

e.textureSize(cond) = ceil(max(diskSize) + period);

% rotate co-ordinate system
phi = 2*pi*spatFreq * (1:e.textureSize(cond));
[x,y] = meshgrid(phi,phi);
R = [sin(ori) cos(ori)];
phi = [x(:) y(:)] * R';
phi = reshape(phi,e.textureSize(cond),[]);

% generate grating
grat = 127.5 + (127.5 * sin(phi + phase) * contrast / 100);

% color grating
color = permute(color,[2 3 1]);
grat = bsxfun(@times,color,grat);

% create texture
e.textures(cond) = Screen('MakeTexture',get(e,'win'),grat);
