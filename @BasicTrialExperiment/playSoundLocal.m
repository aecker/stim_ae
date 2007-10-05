function e = playSoundLocal(e,soundType)
% Play sound file (blocking) and put event.
% AE 2007-02-21

% get sound vectors
sounds = get(e,'soundWaves');
t = GetSecs;
sound(sounds.(soundType));

% put event
e.data = addEvent(e.data,[soundType, 'Sound'],t);
