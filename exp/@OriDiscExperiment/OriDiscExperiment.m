function e = OriDiscExperiment
% Orientation discrimination
% AE 2010-10-24

% reference to texture and alpha mask
e.texture = [];
e.textureSize = [];
e.alphaMask = [];

t = TrialBasedExperiment(ModifiedStairCase,StimulationData);
e = class(e,'OriDiscExperiment',t);
