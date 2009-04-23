function e = FlePhysEffExperiment(varargin)
% Moving and flashed bars for FLE electrophysiology.
%   In this version of the experiment multiple moving and/or flashed bars are
%   presented in each trial to make more efficient use of experimental time.
%
% AE 2009-03-15

% bar texture handle
e.tex = [];

% real randomization is put at initialization
t = TrialBasedExperiment(NoRandomization,StimulationData);
e = class(e,'FlePhysEffExperiment',t);
