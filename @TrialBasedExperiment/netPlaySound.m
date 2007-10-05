function [e,retInt32,retStruct,returned] = netPlaySound(e,params)
% Play sound file
% AE 2007-10-05

% get sound vectors
sounds = get(e,'soundWaves');
t = GetSecs;
sound(sounds.(params.soundType));

% put event
e.data = addEvent(e.data,[soundType, 'Sound'],t);

retInt32 = int32(0);
retStruct = struct;
returned = false;
