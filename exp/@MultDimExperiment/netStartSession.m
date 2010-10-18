function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% calculate disk size in case of full-screen grating
ndx = find(params.diskSize < 0);
if ~isempty(ndx)
    rect = Screen(get(e,'win'),'Rect');
    sz = diff(reshape(rect,2,2),[],2);
    params.diskSize(ndx) = sqrt(sz'*sz) + 5;
end

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% Generate alpha masks

% determine size
maxPeriod = max(e.textureSize) - max(params.diskSize);
e.alphaMaskSize = ceil(max(params.diskSize) / 2 + maxPeriod) + 5;

nDiskSizes = numel(params.diskSize);
e.alphaMask = zeros(1,nDiskSizes);
e.alphaDiskSize = zeros(1,nDiskSizes);
for i = 1:nDiskSizes
    bgColor = getSessionParam(e,'bgColor',1);
    diskSize = params.diskSize(i);
    x = -e.alphaMaskSize:e.alphaMaskSize-1;
    [X,Y] = meshgrid(x,x);
    alphaLum = repmat(permute(bgColor,[2 3 1]),2*e.alphaMaskSize,2*e.alphaMaskSize);
    alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
    e.alphaMask(i) = Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend));
    e.alphaDiskSize(i) = diskSize;
end
