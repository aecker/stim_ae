function r = WNOriDetectRandomization(varargin)
% Randomization for white noise orientation detection experiment.
%
% AE 2012-11-26

r.params = struct;
r.feature = {};

r.pools.bias = [];
r.pools.signal = {};
r.pools.location = {};
r.pools.coherence = {};
r.pools.seed = {};

r.current.bias = 0;
r.current.condition = 0;

r.trial = 0;

r = class(r, 'WNOriDetectRandomization');
