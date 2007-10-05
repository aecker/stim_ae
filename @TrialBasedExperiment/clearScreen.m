function e = clearScreen(e)
% Clear the screen and save timestamp.

% Clear screen
win = get(e,'win');
Screen('FillRect',win,getParam(e,'bgColor'));
e.data = addEvent(e.data,'clearScreen',vblTime);
