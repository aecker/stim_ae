function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% full-screen grating?
ndx = find(params.diskSize < 0);
if ~isempty(ndx)
    rect = Screen(get(e,'win'),'Rect');
    sz = diff(reshape(rect,2,2),[],2);
    params.diskSize(ndx) = sqrt(sz'*sz) + 5;
end

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% also put constants into condition structure
data = get(e,'data');
cond = getConditions(data);
toRand = {'orientation','spatialFreq','contrast','luminance','color','speed','initialPhase'};
f = fieldnames(cond);
for i = 1:numel(toRand)
    ndx = strmatch(toRand{i},f,'exact');
    if isempty(ndx)
        [cond.(toRand{i})] = deal(params.(toRand{i}));
    end
end
e = set(e,'data',setConditions(data,cond));

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
