function e = clearScreen(e)
% Clear the screen and save timestamp.

% Clear screen
win = get(e,'win');
Screen('FillRect',win,e.curParams.bgColor);
vblTime = Screen('Flip',win);
e.data = addEvent(e.data,'clearScreen',vblTime);
