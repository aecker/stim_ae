function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

r.white = trialCompleted(r.white,valid,varargin);

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

