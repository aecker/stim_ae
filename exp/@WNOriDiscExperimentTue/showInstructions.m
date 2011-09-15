function e = showInstructions(e)
% Show instructions for subject.
% AE 2011-09-14

win = get(e, 'win');
bg = getSessionParam(e, 'bgColor');
spatFreq = getSessionParam(e, 'spatialFreq');
diskSize = getSessionParam(e, 'diskSize');
contrast = getSessionParam(e, 'contrast');
c = getSessionParam(e, 'monitorCenter');

% make texture
pxPerDeg = getPxPerDeg(getConverter(e));
spatFreq = spatFreq / pxPerDeg(1);
sz = ceil(diskSize / 2);
phi = 2 * pi * spatFreq * (-sz:sz-1);
grating = repmat(0.5 + 0.5 * contrast * sin(phi), diskSize, 1);
[X, Y] = meshgrid(-sz:sz-1, -sz:sz-1);
isBg = sqrt(X.^2 + Y.^2) > diskSize / 2;
grating(isBg) = bg;
floatPrecision = 1;
texture = Screen('MakeTexture', win, grating, [], [], floatPrecision);

% display the two possible gratings to be detected and associated button
% colors
orientations = getSessionParam(e, 'signals');
responseButtons = getSessionParam(e, 'responseButtons');
colors = {'red', 'yellow', 'green', 'blue', 'white'};
Screen('FillRect', win, bg);
for i = 1:2
    % gratings
    ctr = [c(1) c(2) c(1) c(2)] + [2*(-1)^i 0 2*(-1)^i 0] * sz;
    destRect = ctr + [-1 -1 1 1] * sz;
    Screen('DrawTexture', win, texture, [], destRect, orientations(i) + 90);
    
    % indicate button colors
    Screen('TextSize', win, 36);
    DrawFormattedText(win, colors{responseButtons(i)}, ctr(1) - 50, ctr(2) + diskSize / 2 + 20, 0);
end
Screen('Close', texture);

% add instruction text
instruction = ...
    ['Fixate your eyes on the red dot in the center of the screen.\n' ...
     'The stimulus you will see changes its orientation randomly very fast.\n' ...
     'In each trial, one of the two orientations shown below will occur more\n' ...
     'often than the other orientations.\n' ...
     'Indicate your choice by pressing the associated button shown below.\n\n' ...
     'Press the white button to start.'];
Screen('TextSize', win, 36);
DrawFormattedText(win, instruction, 'center', 150, 0);
Screen('Flip', win);

% repsonsepixx buttons
startButton = 5;
buttonsOff = [0 0 0 0 0];
waitForButton(startButton, buttonsOff);
Screen('FillRect', win, bg);
Screen('Flip', win);


