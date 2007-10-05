function timer = reset(timer)
% Reset the timer.
%   This will reset the color of the photodiode spot to white and clear the
%   buffer swap time buffer.
%
% AE 2007-02-22

timer.swaps = zeros(timer.bufferSize,1);
timer.nSwaps = 0;
