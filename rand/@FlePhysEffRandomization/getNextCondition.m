function [c,r] = getNextCondition(r)
% Returns the parameters for the next condition and removes it from the pool.
%   [c,r] = getNextCondition(r)
%
% AE 2009-03-16

% save previous state to be able to put back one condition
r.whiteBackup = r.white;

% get one condition
[c,r.white] = getParams(r.white,1);
