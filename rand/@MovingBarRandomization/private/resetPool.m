function r = resetPool(r)
% Reset condition pool.
% AE 2007-10-05

n = round(r.movingTrials * r.params.prior(r.currentPrior));
r.conditionPool = [zeros(1,n), ones(1,r.movingTrials-n)];
