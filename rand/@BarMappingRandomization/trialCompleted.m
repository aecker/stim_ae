function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

r.block = trialCompleted(r.block,valid,varargin);
r.white(r.curCond) = trialCompleted(r.white(r.curCond),valid,varargin);

% Indicates whether this was the last trial in current block
canStop = true;
mustStop = false;

