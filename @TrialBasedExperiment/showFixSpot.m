function e = showFixSpot(e)

% Put fixation spot
win = get(e,'win');
Screen('FillRect',win,e.curParams.bgColor);
drawFixSpot(e);
vblTime = Screen('Flip', win);

% store timestamp
e.data = addEvent(e.data,'showFixSpot',vblTime);
