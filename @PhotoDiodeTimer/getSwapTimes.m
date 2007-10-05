function swaps = getSwapTimes(timer)
% Retrieve buffer swap times.
% AE 2007-02-22

swaps = timer.swaps(1:timer.nSwaps);
