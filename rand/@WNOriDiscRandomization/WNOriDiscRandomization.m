function r = WNOriDiscRandomization
% Randomization for white noise orientation discrimination
% AE 2010-10-14

% conditions
r.conditions = [];

% some parameters
r.fixedSeedNum = [];
r.randSeedNum = [];
r.phases = [];
r.orientations = [];
r.signals = [];
r.stepSize = [];

% seeds for fixed seed trials (((((TODO))))))
r.seeds = [];

% list of levels already shown
r.levels = [];

% signal and difficulty level is handled by staircase procedure
r.stair = [];

% randomization to manage fixed vs. random seed trials
r.seedRand = {};
r.newSeedRand = [];

% randomization to manage phases
r.phaseRand = {};
r.newPhaseRand = [];

% randomization to manage noise orientations within each signal condition
r.noiseRand = {};
r.newNoiseRand = [];

% to keep track of which white noise randomization is the current one
r.curSignalIndex = [];
r.curLevelIndex = [];
r.curCondIndex = [];
r.curSeedIndex = [];
r.curPhaseIndex = [];

r = class(r,'WNOriDiscRandomization');
