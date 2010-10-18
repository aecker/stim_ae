function [params,r] = getNoiseParams(r,n)
% Return n params from the noise pool of the current signal condition.
% AE 2010-10-14

c = r.currentCond;
[params,r.noiseWhite{c}] = getParams(r.noiseWhite{c},n);
