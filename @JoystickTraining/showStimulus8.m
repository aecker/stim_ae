function e = showStimulus6(e)
% Show orientation gratings.
% !! TODO: incorporate speed parameter !!
e = putTrialData(e,'stimulus', 8);

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');
params = get(e,'params');

% some shortcuts
if(isempty(e.textures))
    e = generateGaborTextures(e);
end
texture = squeeze(e.textures(curIndex.contrast,curIndex.spatialFreq,:));
rect = Screen('Rect',win);

%1 means A is answer and on left, 2 means B is answer and on right, 3 means B is
%answer and on left, 4 means A is answer and on right
targetSetup = curParams.targetSetup;

theta = 0:.1:359.9;
if((targetSetup == 1) | (targetSetup == 4))
    distribution = eval(curParams.distributionA{1});
    correctColor = curParams.targetAColor;
elseif((targetSetup == 2) | (targetSetup == 3))
    distribution = eval(curParams.distributionB{1});
    correctColor = curParams.targetBColor;
else
    error('No distribution selected');
end
cdf = cumsum(distribution)/sum(distribution);

if((targetSetup == 1) | (targetSetup == 2))
    leftTargetColor = curParams.targetAColor;
    rightTargetColor = curParams.targetBColor;
else
    leftTargetColor = curParams.targetBColor;
    rightTargetColor = curParams.targetAColor;
end    

targetDiameter = curParams.targetDiameter;
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
targetOffset = curParams.targetOffset;


try %this will fail if there was not a previous trial or direction
    correct = getPrev(getTrialData(e),'correctResponse');
	direction = getPrev(getTrialData(e),'trialDirection');
    
    % Note: THIS IS A CLUDGE
    % currently if the animal has a premature movement, this aborts the
    % trial before this function and the direction is not caught from
    % trial to trial, but rather than have this function search in the
    % history for the last valid trial I pick a new one.  This probably
    % means direction ideally would be randomized in the startTrial
    % function, thus avoiding this problem and having premature aborts
    % treated like wrong answers or no answers.
    if(direction == 400)
        correct = 1;
    end
catch %in which case pretend it was correct to generate a new one
    correct = 1;
end

% For now want it to always pick a new direction
correct = 1;

if(correct == 1)
    direction = interp1([0 cdf],[theta 360],rand);
end

e = putTrialData(e,'trialDirection',direction);

% control loop: we remove the stimulus after params.stimTime seconds or a
% tcp abort command, whichever comes first.
endTime = inf;
i = 0;
T = zeros(curParams.stimTime/10,1);

numFrames = length(texture);

t1 = GetSecs;

while GetSecs < endTime


    % Check for abort signal
    fctName = pnet(con,'readline',2^16,'view','noblock');
    if ~isempty(fctName)
        % clear read buffer and abort
        pnet(con,'readline');
        e = feval(fctName,e);
        return;
    end


%    if((GetSecs - t1) < 1)
        Screen('glPoint',win,leftTargetColor,halfWidth-targetOffset,halfHeight,targetDiameter);
        Screen('glPoint',win,rightTargetColor,halfWidth+targetOffset,halfHeight,targetDiameter);    
%    else
        % update grating
        wg = params.diskSize; %wg - width of grating.
        crect = CenterRect([0 0 wg wg],rect);
        Screen('DrawTexture',win,texture(1+mod(i*curParams.speed,numFrames)),[0 0  wg wg],crect,-direction); 
%    end
    % draw fixspot
%    drawFixSpot(e);
   
%     fprintf('this iteration: %6.2f\n',(GetSecs-t1)*1000)
    T(i+1) = (GetSecs - t1) * 1000;

    % flip buffers
    vblTime = Screen('Flip',win);
    
    % first iteration. store start time and compute end time
    if i == 0
        e = addEvent(e,'showStimulus',vblTime);
        endTime = vblTime + curParams.stimTime/1000;
    end
    i = i+1;
end

% send 'completed' to state system
pnet(con,'write',uint8(1));

% clear screen
e = clearScreen(e);

