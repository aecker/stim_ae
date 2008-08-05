function [r,condIndex] = getNextTrial(r)
% AE & MS 2008-07-17

[r.block,condIndex] = getNextTrial(r.block);
r.curCond = condIndex;
