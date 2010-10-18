function [r,mustStop] = trialCompleted(r,valid,varargin)

% block randomization manages which signal orientation and noise level is
% shown in each trial
r.signalBlock = trialCompleted(r.signalBlock,valid,varargin{:});

% white noise randomization might need to reset their pools if trial was
% invalid
r.signalWhite = trialCompleted(r.signalWhite,valid,varargin{:});
c = r.currentCond;
r.noiseWhite{c} = trialCompleted(r.noiseWhite{c},valid,varargin{:});

mustStop = false;

