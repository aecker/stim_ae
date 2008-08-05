function [e,rnd] = initRand(e)
% Initialize randomization object.
% AE & MS 2008-07-17

dotNumX = getParam(e,'dotNumX');
dotNumY = getParam(e,'dotNumY');
dotColor = getParam(e,'dotColor');
x = 1:dotNumX;
y = 1:dotNumY;
c = 1:size(dotColor,2);
[X,Y,C] = meshgrid(x,y,c);
rnd = get(e,'randomization');
rnd = setParams(rnd,[X(:) Y(:) C(:)]');
e = set(e,'randomization',rnd);
