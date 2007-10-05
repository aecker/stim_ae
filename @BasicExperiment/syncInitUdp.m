function e = syncInitUdp(e)
% Initialize clock syncronization.
%   The state system initializes syncronization by calling syncInit. 
%   We time round trips until <2ms, then compute offset of the two clocks.

% get current time
syncTimeEnd = GetSecs * 1000;
roundTripTime = syncTimeEnd - e.syncTimeStart;
si.syncTimeStart = e.syncTimeStart;
% fprintf('syncInit: round trip: %6.2f\n',roundTripTime)

% read state system time
stateSysTime = pnet(e.con,'read',1,'double');

% compute offset or request another timestamp
if roundTripTime < e.maxRoundTripTime
    % this offset has to be added to the time, in order to convert to state
    % system time
    e.timeOffsetStart = double(stateSysTime) + roundTripTime/2 - syncTimeEnd;
    e.syncTimeStart = -Inf;
    pnet(e.con,'write',uint8(1));
    pnet(e.con,'writepacket');
else
    e.syncTimeStart = GetSecs * 1000;
    pnet(e.con,'write',uint8(0));
    pnet(e.con,'writepacket');
end

% DEBUG ------------------------------------
si.roundTripTime = roundTripTime;
si.syncTimeEnd = syncTimeEnd;
si.stateSysTime = stateSysTime;
if isempty(e.si)
    e.si = si;
else
    e.si(end+1) = si;
end

% if length(e.si) > 10, keyboard, end
