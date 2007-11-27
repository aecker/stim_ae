function r = setMaxBlockSize(r,maxBlockSize)

r.maxBlockSize = maxBlockSize;
r.totalMaxBlockSize = max(r.totalMaxBlockSize,maxBlockSize);

r = computeConditions(r);
r = resetPool(r);
