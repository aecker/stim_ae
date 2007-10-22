function e = clearScreen(e)
% Clear the screen and save timestamp.

% Clear screen
win = get(e,'win');
Screen('FillRect',win,getParam(e,'bgColor'));
swapTime = Screen('Flip',win);
e.data = addEvent(e.data,'clearScreen',swapTime);
