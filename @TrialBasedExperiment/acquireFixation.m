function e = acquireFixation(e)
% Get timestamp of monkey acquiring fixation

% Read timestamp from network
timeStamp = pnet(get(e,'con'),'read',1,'double');

% Append event
e.data = addEvent(e.data,'acquireFixation',timeStamp);
