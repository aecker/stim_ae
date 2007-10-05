function e = syncFinalUdp(e)
% Finalize clock syncronization.
%   Offset of the two clocks at the end of a trial is computed.
%   Local timestamps are translated to state system time.

% get current time
syncTimeEnd = GetSecs * 1000;
roundTripTime = syncTimeEnd - e.syncTimeStart;
% fprintf('syncFinal: round trip: %6.2f\n',roundTripTime)
 
% read state system time
stateSysTime = pnet(e.con,'read',1,'double');

% compute offset or request another timestamp
if roundTripTime < e.maxRoundTripTime
    % this offset has to be added to the time, in order to convert to state
    % system time
    timeOffsetEnd = double(stateSysTime) + roundTripTime/2 - syncTimeEnd;
    e.syncTimeStart = -Inf;
    pnet(e.con,'write',uint8(1));
    pnet(e.con,'writepacket');
    
    % TODO: transform times to state system times...
    fprintf('Difference of offsets (startTrial,endTrial) = %6.2f\n', ...
        timeOffsetEnd - e.timeOffsetStart)
    fprintf('Round trip time = %6.2f\n', roundTripTime)
    
else
    e.syncTimeStart = GetSecs * 1000;
    pnet(e.con,'write',uint8(0));
    pnet(e.con,'writepacket');
end
