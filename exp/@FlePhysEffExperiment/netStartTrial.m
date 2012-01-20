function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.
% AE 2009-03-15
% MS 2012-01-16
% parent's inialization
[e,retInt32,retStruct,returned] = initTrial(e,params);

% determine conditions to show in this trial
refresh = get(e,'refreshRate');
rnd = get(e,'randomization');
cond = getConditions(rnd);

maxStimTime   = getParam(e,'maxStimulusTime');
interStimTime = getParam(e,'interStimulusTime');
postStimTime  = getParam(e,'postStimulusTime');
trajLen       = getParam(e,'trajectoryLength');
nLocs         = getParam(e,'numFlashLocs');
combined      = getParam(e,'combined');
locDist     = getParam(e,'flashLocDistance');

onsets = [];
conditions = [];
stimTime = 0;
completed = false;
while ~completed

    % get the next condition
    [c,rnd] = getNextCondition(rnd);
    isStop = cond(c).isStop;
    isInit = cond(c).isInit;
    % calculate time the stimulus takes
    if ~cond(c).isMoving
        thisStimTime = 1000 / refresh;
    else % Moving stimuli
        trajFrames = ceil(trajLen / cond(c).dx);
        trajFrames = trajFrames - (mod(trajFrames,2) ~= mod(nLocs,2));
              
        if isStop || isInit
            dir = cond(c).direction;
            loc = cond(c).flashLocation;
            dx  = cond(c).dx;
            if combined
                % In case of combined stimulus, the moving bar disappears
                % or starts to appear at the center irrespective of flash location
                nFrames = (trajFrames + 1) / 2;
            else
                % in case of the individual stimuli, the moving bar
                % appears or disappears at the different flash locations
                
                relFlashDist = (loc - (nLocs + 1) / 2) * locDist;
                flipSign = ((-1)^dir)*((-1)^isStop);
                pixToMove = (trajFrames * dx/2) - flipSign * relFlashDist;
                nFrames = ceil(pixToMove/dx);
              
%                 if d
%                     nFrames = (trajFrames - nLocs) / 2 + loc;
%                 else
%                     nFrames = (trajFrames - nLocs) / 2 + (nLocs - loc + 1);
%                 end
            end
        else % Continuous motion condition
            nFrames = trajFrames;
        end
        thisStimTime = nFrames * 1000 / refresh;
    end
    % 'onsets' are cumulative subTrial endTimes (MS,2012-01-12)
    % test whether we can fit this stimulus
    if stimTime + thisStimTime <= maxStimTime
        stimTime = stimTime + thisStimTime + interStimTime;
        onsets(end+1) = stimTime;                                          %#ok<AGROW>
        conditions(end+1) = c;                                             %#ok<AGROW>
    else
        % didn't fit in any more, put it back into condition pool
        rnd = putBackPreviousCondition(rnd);
        % we don't need an interStimTime after the last stim, postStimTime
        % takes care of that.
        stimTime = stimTime - interStimTime;
        onsets(end) = stimTime + postStimTime;      %#ok<AGROW>
        completed = true;
    end
end

fprintf('Cumulative SubTrial lengths(ms): %s\n',sprintf('%d ',onsets))
fprintf('Conditions: %s\n',sprintf('%d ',conditions))
fprintf('Stimulus time: %d\n',stimTime)
fprintf('\n\n')

% important: write back randomization
e = set(e,'randomization',rnd);

% save onsets and conditions
e = setTrialParam(e,'onsets',onsets);
e = setTrialParam(e,'conditions',conditions);

% save stimulus time and send to LabView
delayTime = stimTime + getParam(e,'postStimulusTime');
e = setTrialParam(e,'stimulusTime',stimTime);
e = setTrialParam(e,'delayTime',delayTime);
retStruct.delayTime = delayTime;
