function e = netStartTrial(e)
% Start a new trial.

% Request parameters
[e.randomization,indices,condIndex] = getNextTrial(e.randomization);

% Update current parameters
paramNames = fieldnames(e.params);
for i = 1:length(paramNames)
    p = paramNames{i};
    e.curParams.(p) = e.params.(p)(:,indices(i));
    e.curIndex.(p) = indices(i);
end

% set background & get starting time
win = get(e,'win');
Screen('FillRect',win,e.curParams.bgColor);
startTime = Screen('Flip',win);

% play sound
e = playSound(e,'startTrial');

% init new trial
e.data = newTrial(e.data);

% put condition
e.data = set(e.data,'condition',condIndex);

% add startTrial event
e.data = addEvent(e.data,'startTrial',startTime);

% send acknowledgement
%pnet(get(e,'con'),'write',uint8(1));
