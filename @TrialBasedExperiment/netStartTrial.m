function [e,retInt32,retStruct,returned] = netStartTrial(e)
% Start a new trial.

% determine condition
[e.randomization,condIndex] = getNextTrial(e.randomization);
e.data = newTrial(e.data);
e.data = setTrialData(e.data,'condition',condIndex);

% set background & get starting time
win = get(e,'win');
Screen('FillRect',win,getParam(e,'bgColor'));
startTime = Screen('Flip',win);
e.data = addEvent(e.data,'startTrial',startTime);

% do trial initialization
e = initTrial(e);

% play sound
warning('TrialBasedExperiment:netStartTrial: what does the sound indicate? Fixation spot to appear soon? If yes, it has to be moved to the appropriate function since startTrial is now before interTrial')
e = playSound(e,'startTrial');

retInt32 = int32(0);
retStruct = struct;
returned = false;
