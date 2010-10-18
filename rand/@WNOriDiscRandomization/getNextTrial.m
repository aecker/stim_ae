function [r,condIndex] = getNextTrial(r)
% AE 2010-10-14

% let white noise randomization know a new trial started
r.signalWhite = getNextTrial(r.signalWhite);

% determine signal condition for this trial
[r.currentCond,r.signalWhite] = getParams(r.signalWhite,1);
condIndex = r.currentCond;

r.noiseWhite{condIndex} = getNextTrial(r.noiseWhite{condIndex});
