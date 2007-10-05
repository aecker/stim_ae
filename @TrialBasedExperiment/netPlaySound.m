function [e,retInt32,retStruct,returned] = netPlaySound(e,params)
% Play sound file (blocking)
% AE 2007-02-21

% connection handle
con = get(e,'con');

% read what type of sound to play (startTrial | reward | eyeAbort | leverAbort)
soundType = pnet(con,'readline');

% get sound vectors
sounds = get(e,'soundWaves');
t = GetSecs;
sound(sounds.(soundType));

% confirm execution
pnet(con,'write',uint8(1));

% put event
e.data = addEvent(e.data,[soundType, 'Sound'],t);
