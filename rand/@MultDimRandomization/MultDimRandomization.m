function r = MultDimRandomization
% Randomization for multidimensional coding stimulus
% AE 2008-12-18

% block randomization to create all combinations of parameters
r.block = BlockRandomization('location','orientation','spatialFreq', ...
    'contrast','luminance','color','speed','initialPhase');

% white noise randomization to determine which conditions to show in each
% frame
r.white = WhiteNoiseRandomization;

r = class(r,'MultDimRandomization');
