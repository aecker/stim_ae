function r = resetPool(r)
% Reset condition pool.
% AE 2007-10-05

nI = length(r.imageList);
r.conditionPool = randperm(nI);
