function [r,mustStop] = trialCompleted(r,valid,varargin)

r.block = trialCompleted(r.block,valid,varargin{:});
r.white(r.curCond) = trialCompleted(r.white(r.curCond),valid,varargin{:});
mustStop = false;

