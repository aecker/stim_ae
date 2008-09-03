function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

r.block = trialCompleted(r.block,valid,varargin);

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

