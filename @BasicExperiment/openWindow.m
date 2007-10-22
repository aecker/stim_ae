function [e,ret] = openWindow(e)
% Open PTB window

% Screen is able to do a lot of configuration and performance checks on
% open, and will print out a fair amount of detailed information when
% it does.  These commands supress that checking behavior and just let
% the demo go straight into action.  See ScreenTest for an example of
% how to do detailed checking.
Screen('Preference','VisualDebugLevel',3);
Screen('Preference','SuppressAllWarnings',1);

% determine screen to use
whichScreen = max(Screen('Screens'));

% Hides the mouse cursor
% HideCursor;

% Opens a graphics window on the main monitor (screen 0).  If you have
% multiple monitors connected to your computer, then you can specify
% a different monitor by supplying a different number in the second
% argument to OpenWindow, e.g. Screen('OpenWindow', 2).
e.win = Screen('OpenWindow', whichScreen);
e.refreshRate = Screen(whichScreen,'FrameRate',[]);
HideCursor;

% confirm execution
ret = 1;
