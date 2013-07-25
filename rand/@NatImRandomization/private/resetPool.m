function r = resetPool(r)
% Reset condition pool.
% AE 2007-10-05

r.conditionPool = 1 : numel(r.conditions);

