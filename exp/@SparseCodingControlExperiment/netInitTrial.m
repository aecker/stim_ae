function [e,retInt32,retStruct,returned] = netInitTrial(e,varargin)
% Initialize trial.
% AE 2009-03-24

% compute post-stimulus fixation time
delayTime = getParam(e,'delayTime');
stimTime = getParam(e,'stimulusTime');
e = setTrialParam(e,'postStimulusTime',delayTime - stimTime);

% load image for this trial
imagePath = getParam(e,'imagePath');        
n = getParam(e,'imageNumber');          
stat = getParam(e,'imageStat');

% read image
tic
img = imread(getLocalPath(sprintf('%s\\%05.0f_%s.tif',imagePath,n,stat)));
e = setTrialParam(e,'imageName',sprintf('%05.0f_%s.tif',n,stat));

% first release previous texture
if ~isempty(e.currTex)
    Screen('Close',e.currTex);
end

% generate texture
win = get(e,'win');
imgSize = size(img);
diskSize = getParam(e,'diskSize');
fadeFactor = getParam(e,'fadeFactor');    
dx = ceil(fadeFactor*diskSize);
texture = img(imgSize(1)/2 + (-dx+1:dx),imgSize(2)/2 + (-dx+1:dx))';
e.currTex = Screen('MakeTexture',win,texture');
e = setTrialParam(e,'timeToLoad',toc);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = false;
