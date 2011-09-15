function e = WNOriDiscExperimentTue(varargin)
% White noise orientation discrimination for perceptual learning.
% Customized version for Bethge lab hardware.
% AE 2011-09-14

% Some variables we need to precompute the stimulus
e.texture = [];
e.textureSize = [];
e.alphaMask = [];

e = class(e,'WNOriDiscExperimentTue',WNOriDiscExperiment);
