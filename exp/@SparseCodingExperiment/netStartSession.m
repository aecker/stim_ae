function [e,retInt32,retStruct,returned] = netStartSession(e,params)


% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);


getNumConditions(e)

for i = 1:getNumConditions(e)
    fprintf('Loading Condition %d\n',i)
    e = initCondition(e,i);
end

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
