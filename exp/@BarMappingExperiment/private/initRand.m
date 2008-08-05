function [e,rnd] = initRand(e)
% Initialize randomization object.
% AE & MS 2008-07-17

barColor  = getParam(e,'barColor');
barLength = getParam(e,'barLength');
barWidth  = getParam(e,'barWidth');
nBars = fix(barLength / barWidth);
x = 1:nBars;
c = 1:size(barColor,2);
[X,C] = meshgrid(x,c);
rnd = get(e,'randomization');
rnd = setParams(rnd,[X(:) C(:)]');
e = set(e,'randomization',rnd);
