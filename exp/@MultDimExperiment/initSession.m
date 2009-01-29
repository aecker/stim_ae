function e = initSession(e,params,expType)

% initialize parent
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% Since we overwrote initSession, we need to manually initialize the
% conditions now. TrialBasedExperiment/initSession is calling initCondition
% automatically, but since the above call is running only on the parent, it
% calls TrialBasedExperiment/initCondition instead of
% GratingExperiment/initSession.
getNumConditions(e)
for i = 1:getNumConditions(e)
    e = initCondition(e,i);
end

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% Generate alpha mask
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
location = getSessionParam(e,'location',1);
bgColor = getSessionParam(e,'bgColor',1);
diskSize = getSessionParam(e,'diskSize',1);
[X,Y] = meshgrid((-halfWidth:halfWidth-1) - location(1), ...
             (-halfHeight:halfHeight-1) - location(2));
alphaLum = repmat(permute(bgColor,[2 3 1]), ...
                  2*halfHeight,2*halfWidth);
alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
e.alphaMask = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
