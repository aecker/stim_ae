function e = putStateEvent(e)
% Get timestamp of an event that occured on the state system (e.g. monkey
% acquiring fixation, recieving reward etc.) and store it in the data
% structure.

% Read event and timestamp from network
con = get(e,'con');
eventName = pnet(con,'readline');
timeStamp = pnet(con,'read',1,'double');

% Append event
e.data = addEvent(e.data,eventName,timeStamp);
