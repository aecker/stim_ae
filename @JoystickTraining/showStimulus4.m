function e = showStimulus4(e)
% Show random photograph from two classes (name will be determined in param.imageClass{1...n})
% will be loaded into an array of images called images{class}(element), which will allow a different
% number of elements in each class
e = putTrialData(e,'stimulus', 4);

% some member variables..
win = get(e,'win');
con = get(e,'con');
curParams = get(e,'curParams');
curIndex = get(e,'curIndex');
params = get(e,'params');

rect = Screen('Rect',win);
black = BlackIndex(win);
white = WhiteIndex(win);

HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(win));

curParams.imageClass
curIndex.imageClass
image = e.images{curIndex.imageClass,curIndex.imageNum};

% user defined location of the center of image, given in cartesian
% coordinates in units of pixels.
X = params.location(1);
Y = params.location(2);

% size of the image in pixels
x = size(image,2);
y = size(image,1);

% converting the cartesian coordinates to screen coordinates.
newCenter = [rect(3)/2+X rect(4)/2-Y];

%calculating the desired position of the image in screen coordinates
x1 = newCenter(1)-0.5*x;
y1 = newCenter(2)-0.5*y;
x2 = newCenter(1)+0.5*x;
y2 = newCenter(2)+0.5*y;

targRect = [x1 y1 x2 y2];
% targRect = CenterRect([0 0 x y], rect);
textureIndex = Screen('MakeTexture', win, image, [], []);
Screen('FillRect', win, curParams.bgColor, rect);
Screen('DrawTexture', win, textureIndex, [0 0 x y], targRect, [], []);	
    
% Do initial flip 
vbl=Screen('Flip', win);
    
% --------------
% timer loop
% --------------    
    
% control loop: we remove the stimulus after params.stimTime seconds or a
% tcp abort command, whichever comes first.
endTime = inf;
firstTrial = true;
while GetSecs < endTime

	t1 = GetSecs;

	% Check for abort signal
	fctName = pnet(con,'readline',2^16,'view','noblock');
	if ~isempty(fctName)
		% clear read buffer and abort
		pnet(con,'readline');
		e = feval(fctName,e);
		return;
	end
	
    % draw photodiode spot; do buffer swap and keep timestamp
%    e.photoDiodeTimer = swap(e.photoDiodeTimer,win);
    
    % compute timeout
    if firstTrial
        startTime = vbl;
        endTime = startTime + curParams.stimTime/1000;
        firstTrial = false;
    end
	
end;

Priority(0);

% send 'completed' to state system
pnet(con,'write',uint8(1));

% clear screen
e = clearScreen(e);

