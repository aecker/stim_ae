function [e, retInt32, retStruct, returned] = netStartSession(e, params)
% Start session.
% AE 2011-04-07

% Use custom photodiode spot (larger)
p = PhotoDiodeTimer(150, [0 255], 80);
e = set(e, 'photoDiodeTimer', p);

% Initialization
[e, retInt32, retStruct, returned] = initSession(e, params);
