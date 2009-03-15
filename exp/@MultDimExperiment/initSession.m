function e = initSession(e,params,expType)

% full-screen grating?
ndx = find(params.diskSize < 0);
if ~isempty(ndx)
    rect = Screen(get(e,'win'),'Rect');
    sz = diff(reshape(rect,2,2),[],2);
    params.diskSize(ndx) = sqrt(sz'*sz) + 5;
end

% initialize parent
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% Since we overwrote initSession, we need to manually initialize the
% conditions now. TrialBasedExperiment/initSession is calling initCondition
% automatically, but since the above call is running only on the parent, it
% calls TrialBasedExperiment/initCondition instead of
% GratingExperiment/initSession.
nCond = getNumConditions(e);
e.gammaTables = zeros(256,nCond);
e.textures = zeros(1,nCond);
for i = 1:nCond
    e = initCondition(e,i);
end

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% Generate alpha masks
nDiskSizes = numel(params.diskSize);
e.alphaMask = zeros(1,nDiskSizes);
e.alphaMaskSize = zeros(1,nDiskSizes);
for i = 1:nDiskSizes
    rect = Screen('Rect',win);
    halfWidth = ceil(diff(rect([1 3])) / 2);
    halfHeight = ceil(diff(rect([2 4])) / 2);
    location = getSessionParam(e,'location',1);
    bgColor = getSessionParam(e,'bgColor',1);
    diskSize = params.diskSize(i);
    [X,Y] = meshgrid((-halfWidth:halfWidth-1) - location(1), ...
                 (-halfHeight:halfHeight-1) - location(2));
    alphaLum = repmat(permute(bgColor,[2 3 1]), ...
                      2*halfHeight,2*halfWidth);
    alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
    e.alphaMask(i) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
    e.alphaMaskSize(i) = diskSize;
end
