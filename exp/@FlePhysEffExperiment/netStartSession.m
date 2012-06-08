function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Session initalization
% AE 2010-10-16
% MS 2012-06-07
% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);


% Enable alpha blending
Screen('BlendFunction',get(e,'win'),GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
