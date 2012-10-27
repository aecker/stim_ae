function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Session initalization
% AE 2010-10-16
% MS 2011-09-09
% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% initialize randomization object
e = initRand(e);

Screen('BlendFunction',get(e,'win'),'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');
