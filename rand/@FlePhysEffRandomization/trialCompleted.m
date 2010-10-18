function [r,mustStop] = trialCompleted(r,valid,varargin)

r.white = trialCompleted(r.white,valid,varargin{:});
mustStop = false;

