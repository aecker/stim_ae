function e = initTrial(e)
% Initialize trial.
% AE 2008-08-04

% compute post-stimulus fixation time
delayTime = getParam(e,'delayTime');
stimTime = getParam(e,'stimulusTime');
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);

% load image for this trial
tic
imagePath = getParam(e,'imagePath');        
n = getParam(e,'imageNumber');          
stat = getParam(e,'imageStat');

% read image
img = imread(getLocalPath(sprintf('%s\\%05.0f_%s.tif',imagePath,n,stat)));
e = setTrialParam(e,'imageName',sprintf('%05.0f_%s.tif',n,stat));

% generate texture
win = get(e,'win');
imgSize = size(img);
diskSize = getParam(e,'diskSize');
fadeFactor = getParam(e,'fadeFactor');    
dx = ceil(fadeFactor*diskSize);
texture = img(imgSize(1)/2 + (-dx+1:dx),imgSize(2)/2 + (-dx+1:dx))';
e.currTex = Screen('MakeTexture',win,texture');
e = setTrialParam(e,'timeToLoad',toc);
