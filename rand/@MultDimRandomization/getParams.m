function [params,r] = getParams(r,n)
% Return n params from the pool of the current condition.
% AE 2008-12-18

[params,r.white] = getParams(r.white,n);
