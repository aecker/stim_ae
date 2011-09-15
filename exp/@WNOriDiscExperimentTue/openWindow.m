function [e,ret] = openWindow(e)
% Open PTB window
% This is a modified version of BasicExperiment/openWindow, which is
% customized to the Bethge lab hardware (i.e. for use with Datapixx)
%
% AE 2011-09-13

% Screen is able to do a lot of configuration and performance checks on
% open, and will print out a fair amount of detailed information when it
% does.  These commands supress that checking behavior and just it go
% straight into action
Screen('Preference','VisualDebugLevel',3);
Screen('Preference','SuppressAllWarnings',1);

% Initializing Datapixx will open a window for us
[win, rect] = initializeDatapixx(2,1,[],false);
e = set(e, 'win', win);

% determine refresh rate and screen resolution
refreshRate = Screen(win,'FrameRate',[]);
e = set(e, 'refreshRate', refreshRate);
resolution = diff(rect([1 2; 3 4]))';
e = set(e, 'resolution', resolution);

% Initialize random number generator to random seed (otherwise you get the
% same sequence of random numbers in each Matlab session)
rand('state',sum(100*clock)); %#ok<*RAND>
randn('state',sum(100*clock));

% confirm execution
ret = 1;
