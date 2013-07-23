function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show natural, phase scrambled and whitenoise images in a sophisticated
% randomization pattern bla bla
%
% LG/GD 07/10/2013

win = get(e,'win');
refresh = get(e,'refreshRate');


% read parameters
nIm = getParam(e,'imPerTrial');
imTime = getParam(e,'imTime');
blankTime = getParam(e,'blankTime');
bgColor = getParam(e,'bgColor');
stimTime = nIm*imTime+(nIm-1)*blankTime;
postStimTime = getParam(e,'postStimulusTime');

%write delayTime
params.delayTime = stimTime+postStimTime;


% compute number of frames
 flipInterval = 1000 / refresh; % frame duration in msec ~= 10 msec
% imFrames = imTime / flipInterval; %no. of frames while image is shown
% blankFrames = blankTime/flipInterval; % no. of frames while blank is shown
% totalFrames = imFrames+blankFrames;

% show one randomly drawn sequence of ni images
conditions = getConditions(get(e,'randomization'));
cond = getParam(e,'condition');


imNums = conditions(cond).imNum;
%stat = conditions(cond).stat;
statIdx = conditions(cond).statIndex;

%return function call
tcpReturnFunctionCall(e,int32(0),params,'netShowStimulus');

cIm = 1; % current image in trial sequence
t = -Inf;
blank = true;

while cIm <= nIm
    
    % was there an abort during stimulus presentation?
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('Abort during stimulus\n')
        break
    end
    
    % if blank is shown for blankTime - time of one frame, show image in
    % next frame
    if blank
        if GetSecs-t > (blankTime-flipInterval)/1000
            Screen('DrawTexture',win,e.textures(statIdx(cIm),imNums(cIm)),[],e.destRect);
            Screen('DrawTexture',win,e.alphaMask);
            drawFixSpot(e);
            blank = false;
            
            e = swap(e);
            t = getLastSwap(e);
            
            if cIm == 1
                startTime = getLastSwap(e);
                e = addEvent(e,'showStimulus',startTime);
            end
            
            subStimulusTime = getLastSwap(e);
            e = addEvent(e,'showSubStimulus',subStimulusTime);
        end
        
        % if image is shown for imTime - time of one frame, show blank in next frame
    else
        if GetSecs-t > (imTime-flipInterval)/1000
            
            Screen('FillRect',win,bgColor,e.destRect);
            drawFixSpot(e);
            blank = true;
            e = swap(e);
            t = getLastSwap(e);
            cIm = cIm+1;
            if cIm == nIm
                endTime = getLastSwap(e);
                e = addEvent(e,'endStimulus',endTime);
            end
            
            subStimulusTime = getLastSwap(e);
            e = addEvent(e,'showSubStimulus',subStimulusTime);
        end
    end
    
    
    % wait a little to relax the cpu
    WaitSecs(flipInterval/4000)
    
    
end
WaitSecs((postStimTime-flipInterval)/1000)


% remove fixation spot
if ~abort
    e = clearScreen(e);
end

%e = setTrialParameter(e,'delayTime',delayTime);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;