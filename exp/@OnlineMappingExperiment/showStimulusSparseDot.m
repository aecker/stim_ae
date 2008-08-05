function [e,retInt32,retStruct,returned] = showStimulusSparseDot(e,params)
% shows moving bar
% PHB 2007-11-24

% some member variables..
win     = get(e,'win');
refresh = get(e,'refreshRate');
%rnd     = get(e,'randomization');

% parameters
dotColorDark     = getParam(e,'dotColorDark');
dotColorBright   = getParam(e,'dotColorBright');
dotSize          = getParam(e,'dotSize');
dotFrames        = getParam(e,'dotFrames');
dotRangeCenter   = getParam(e,'dotRangeCenter');
dotRange         = getParam(e,'dotRange');
stimulusTime     = getParam(e,'stimulusTime');


% generate dot textures in both colors
dotColorDark = ones(3,1)*dotColorDark;
texMat = permute(repmat(dotColorDark,[1; dotSize]),[2 3 1]);
dotTexDark = Screen('MakeTexture',get(e,'win'),texMat);

dotColorBright = ones(3,1)*dotColorBright;
texMat = permute(repmat(dotColorBright,[1; dotSize]),[2 3 1]);
dotTexBright = Screen('MakeTexture',get(e,'win'),texMat);

% return function call
% tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');
tcpReturnFunctionCall(e,int32(0),struct('correctResponse',int32(1)),'netShowStimulus');
% initialize
i = 1;
m = ceil(stimulusTime/refresh);
s = zeros(m,2);
r = zeros(m,1);
abort = false;
firstTrial = true;
running = true;
frames = 0;

% stimulation loop
while running

	drawFixspot(e);

    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    if frames==0
        % select a texture
        texRand = rand > .5;
        if texRand
            currTex = dotTexBright;
        else
            currTex = dotTexDark;
        end
        pos = dotRangeCenter + rand(2,1) .* (2*dotRange) - dotRange;
%         fprintf('dot position %.2f %.2f\n',pos(1),pos(2))
        frames = dotFrames-1;
    end
    
    % draw colored rectangle
    rect = [pos - dotSize/2; pos + dotSize/2];
    Screen('DrawTexture',win,currTex,[],rect,0); 
      
    % draw photodiode spot; do buffer swap and keep timestamp
    e = swap(e);
        
    % compute startTime
    if firstTrial
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
        firstTrial = false;
    end
    
    % compute timeOut
    running = (getLastSwap(e)-startTime) < stimulusTime;
    
    % save buffer swap data
    s(i,:)=pos';        % position of dot in frame i
    r(i) = texRand;     % texture shown (1=bright, 0=dark)
    frames = frames-1;  % update number of frames the stimulus is still there
    i = i+1;
end

% clear screen (abort clears the screen anyway in netAbortTrial, so skip it in
% this case)
if ~abort
    e = clearScreen(e);
end

% log stimulus offset event
e = addEvent(e,'endStimulus',getLastSwap(e));

% save bar locations
e = setTrialParam(e,'dotLocations',s(1:i-1,:));
e = setTrialParam(e,'dotTexture',r);
e = setTrialParam(e,'dotTextureBright',dotTexBright);
e = setTrialParam(e,'dotTextureDark',dotTexDark);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
