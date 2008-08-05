function [params,r] = getParams(r,n)
% Return n params from the pool of the current condition.
% AE & MS 2008-07-17

[params,r.white(r.curCond)] = getParams(r.white(r.curCond),n);
