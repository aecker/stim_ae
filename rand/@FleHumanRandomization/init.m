function r = init(r,params) %#ok<INUSD>
% Initialize randomization.
% AE & PhB 2007-10-09

r = computeConditions(r);
r = resetPool(r);
