function [r,condIndex] = getNextTrial(r)
% Don't have to do anything here since we don't have conditions in that
% sense.
% AE & MS 2008-07-14

condIndex = NaN;

% make backup of location pool
r.backup = r.pool;
