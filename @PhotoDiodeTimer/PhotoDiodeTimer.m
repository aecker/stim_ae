function timer = PhotoDiodeTimer(bufferSize)
% Photodiode timing.
% AE 2007-02-22

% buffer size
if nargin < 1
    timer.bufferSize = 100;
else
    timer.bufferSize = bufferSize;
end

% buffer to put the swapping times
timer.swaps = zeros(timer.bufferSize,1);
timer.nSwaps = 0;

% alternating color
timer.colors = {[255 255 255], [128 128 128]};
timer.state = true;

% create class object
timer = class(timer,'PhotoDiodeTimer');
