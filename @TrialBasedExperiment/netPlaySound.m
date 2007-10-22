function [e,retInt32,retStruct,returned] = netPlaySound(e,params)
% Play sound file
% AE 2007-10-05

e = playSound(e,params.soundType);

retInt32 = int32(0);
retStruct = struct;
returned = false;
