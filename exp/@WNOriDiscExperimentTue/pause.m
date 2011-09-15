function e = pause(e)
% Pause experiment until button press.
% AE 2011-09-14

bg = getSessionParam(e, 'bgColor');
win = get(e, 'win');
Screen('FillRect', win, bg);
Screen('TextSize', win, 100);
DrawFormattedText(win, 'Pause :-)', 'center', 200, 0);
Screen('TextSize', win, 32);
DrawFormattedText(win, 'Press white button to continue', 'center', 400, 0);
Screen('Flip', win);

startButton = 5;
buttonsOff = [0 0 0 0 0];
waitForButton(startButton, buttonsOff);
Screen('FillRect', win, bg);
Screen('Flip', win);
