function [orientations,r,actualP] = getOrientations(r,n)
% Return orientations for the current trial
% AE 2011-02-18

% determine signal orientation and probability of occurence
level = getLevel(r.stair);
p = 1 / (1 + exp(-level));
m = round(p * n);
actualP = n / m;
signal = r.signals(r.curSignalIndex);
signal = repmat(signal,1,m);

% get orientations for noise frames
sig = r.curSignalIndex;
level = r.curLevelIndex;
phase = r.curPhaseIndex;
[noise,r.noiseRand{sig,level,phase}] = ...
    getParams(r.noiseRand{sig,level,phase},n-m);

% make random order
orientations = [signal noise];
orientations = orientations(randperm(n));
