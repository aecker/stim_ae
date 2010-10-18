function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% initialize randomization (override default to make sure all parameters
% end up in there)
p.signalBlockSize = params.signalBlockSize;
p.signal = params.signal;
p.signalProb = params.signalProb;
p.orientation = params.orientation;
p.phase = params.phase;
rnd = init(WNOriDiscRandomization,p);
e = set(e,'randomization',rnd);

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
grat = 127.5 + 127.5 * params.contrast * sin(phi);

% color grating
color = permute(params.color,[2 3 1]);
grat = bsxfun(@times,color,grat);

% create texture
e.texture = Screen('MakeTexture',get(e,'win'),grat);

% generate alpha mask
win = get(e,'win');
rect = Screen('Rect',win);
hw = ceil(diff(rect([1 3])) / 2);
hh = ceil(diff(rect([2 4])) / 2);
loc = params.stimulusLocation;
[X,Y] = meshgrid(-hw:hw-1,-hh:hh-1);
alphaLum = repmat(permute(params.bgColor,[2 3 1]),2*hh,2*hw);
alphaBlend = 255 * (sqrt((X - loc(1)).^2 + (Y - loc(2)).^2) > params.diskSize/2);
e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
