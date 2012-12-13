function e = WNOriDetectExperimentTue(varargin)
% White noise orientation detectopm.
% Customized version for Bethge lab hardware.
% AE 2012-11-30

% Some variables we need to precompute the stimulus
e.texture = [];
e.textureSize = [];
e.alphaMask = [];

e = class(e, 'WNOriDetectExperimentTue', WNOriDetectExperiment);
