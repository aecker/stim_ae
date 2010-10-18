function [r,mustStop] = trialCompleted(r,valid,varargin)

r.block = trialCompleted(r.block,valid,varargin{:});
mustStop = false;

