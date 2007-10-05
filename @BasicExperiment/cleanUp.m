function e = cleanUp(e)
% Reset initial settings to state before start of experiment.

% close PTB window
Screen('Close',e.win)

% restore settings
Screen('Preference','VisualDebugLevel',e.oldVisualDebugLevel);
Screen('Preference','SuppressAllWarnings',e.oldSupressAllWarnings);
