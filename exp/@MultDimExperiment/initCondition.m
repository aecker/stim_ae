function e = initCondition(e,cond)
% Condition-specific initialization.
% AE 2007-12-17

% generate grating texture
diskSize = getSessionParam(e,'diskSize',cond);
spatFreq = getSessionParam(e,'spatialFreq',cond);
phase    = getSessionParam(e,'initialPhase',cond);
color    = getSessionParam(e,'color',cond);
pxPerDeg = getPxPerDeg(getConverter(e));
spatFreq = spatFreq / pxPerDeg(1);
period = 1 / spatFreq;

% texture needs to be a bit larger because we're going to move it under the
% aperture to generate the motion
e.textureSize(cond) = ceil(diskSize + period);

% rotate co-ordinate system
phi = 2*pi*spatFreq * (1:e.textureSize(cond));
grat = 127.5 + 126.5 * sin(phi + phase);

% color grating
color = permute(color,[2 3 1]);
grat = bsxfun(@times,color,grat);

% create texture
e.textures(cond) = Screen('MakeTexture',get(e,'win'),grat);

% manipulated gamma table to achieve specified luminance
contrast = getSessionParam(e,'contrast',cond);
luminance = getSessionParam(e,'luminance',cond);

% determine available range of luminance
gammaTab = get(e,'gammaTable');
lumTab = get(e,'luminanceTable');
minLum = lumTab(1);
maxLum = lumTab(end);
minLumNew = (1 - contrast) * luminance;
maxLumNew = 2 * luminance - minLumNew;
x0 = 255 * (minLumNew - minLum) / (maxLum - minLum);
x255 = 255 * (maxLumNew - minLum) / (maxLum - minLum);
assert(x0 >= 0 && x255 <= 255 ,'MultDimExperiment:invalidContrast', ...
    'Contrast/luminance combination is out of range of current monitor settings: (%.1f, %.1f) cd/m^2', ...
    lumTab(1),lumTab(end))

% intensity values 0 and 255 are reserved for the PhotodiodeTimer; the
% remaining values are fully used by the grating and contrast+luminance are
% adjusted by manipulating the gamma table
modGammaTab = interp1(0:255,gammaTab,linspace(x0,x255,254),'cubic');
e.gammaTables(:,cond) = [0; modGammaTab'; 1]; 
