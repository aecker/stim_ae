function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Moving and flashed bars for Flash-Lag effect electrophysiology.
% AE 2008-09-02

e = setTrialParam(e,'barLocations',{});
e = setTrialParam(e,'barRects',{});
e = setTrialParam(e,'barCenters',{});
e = setTrialParam(e,'flashLocations',{});
e = setTrialParam(e,'flashRects',{});
e = setTrialParam(e,'flashCenters',{});

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

% iterate through random conditions for as long as we have time available
conditions = getConditions(get(e,'randomization'));
cond = getParam(e,'conditions');
onsets = getParam(e,'onsets');
startTime = GetSecs;
for i = 1:numel(onsets)
    
    % show stimulus
    c = cond(i);
    if ~conditions(c).isMoving
        [e,abort,s] = showFlashedBar(e,c,i==1);
    else
        [e,abort,s] = showMovingBar(e,c,i==1);
    end
    
    % update start time after first substimulus
    if i == 1
        startTime = s;
    end
    
    % was there an abort during stimulus presentation?
    if abort
        fprintf('Abort during stimulus\n')
        break
    end

    endTime = getLastSwap(e);
    e = addEvent(e,'endSubStimulus',endTime);
    

    % was this the last one?
    if i == numel(onsets)
        e = addEvent(e,'endStimulus',endTime);
    end

    % wait between stimuli
    [e,abort] = waitUntil(e,startTime + onsets(i)/1000);
    if abort
        fprintf('Abort during interStimTime\n')
        break
    end
end

% remove fixation spot
if ~abort
    e = clearScreen(e);
end

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
