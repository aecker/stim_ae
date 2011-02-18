function [r,mustStop] = trialCompleted(r,valid,varargin)

level = r.curLevelIndex;
signal = r.curSignalIndex;
seed = r.curSeedIndex;
phase = r.curPhaseIndex;

% notify all randomizations
r.seedRand{signal,level} = trialCompleted(r.seedRand{signal,level},valid);
r.phaseRand{signal,level,seed} = trialCompleted(r.phaseRand{signal,level,seed},valid);
r.noiseRand{signal,level,phase} = trialCompleted(r.noiseRand{signal,level,phase},valid);

mustStop = false;
