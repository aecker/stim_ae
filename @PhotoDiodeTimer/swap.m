function timer = swap(timer,win)
% Do buffer swap and keep timestamp.
% AE 2007-02-22

% draw dot with alternating color
color = timer.colors{timer.state+1};
timer.state = ~timer.state;
Screen('glPoint',win,color,10,10,10);

% do buffer swap
swapTime = Screen('Flip',win);

% put timestamp
timer.nSwaps = timer.nSwaps + 1;
timer.swaps(timer.nSwaps) = swapTime;
