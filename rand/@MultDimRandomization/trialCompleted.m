function [r,canStop,mustStop] = trialCompleted(r,valid,varargin)

r.white = trialCompleted(r.white,valid,varargin);

canStop = true;
mustStop = false;

