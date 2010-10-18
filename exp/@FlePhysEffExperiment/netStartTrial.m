function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start a new trial.
% AE 2009-03-15

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

onsets = [];
conditions = [];
stimTime = 0;
completed = false;
while ~completed

    % look what the next condition would be (doesn't take it out of the pool)
    [c,rnd] = getNextCondition(rnd);
    
    % calculate time the stimulus takes
    if ~cond(c).isMoving
        thisStimTime = 1000 / refresh;
    else
        trajFrames = ceil(trajLen / cond(c).dx);
        trajFrames = trajFrames - (mod(trajFrames,2) ~= mod(nLocs,2));
        if ~cond(c).isStop
            nFrames = trajFrames;
        else
            dir = cond(c).direction;
            loc = cond(c).flashLocation;
            if combined
                % In case of combined stimulus, the moving bar disappears at the
                % enter irrespective of flash location 
                nFrames = (trajFrames + 1) / 2;
            else
                % in case of the individual stimuli, the moving bar disappears
                % at the different flash locations
                if ~dir
                    nFrames = (trajFrames - nLocs) / 2 + loc;
                else
                    nFrames = (trajFrames - nLocs) / 2 + (nLocs - loc + 1);
                end
            end
        end
        thisStimTime = nFrames * 1000 / refresh;
    end
    
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
        onsets(end) = stimTime + postStimTime;                             %#ok<AGROW>
        completed = true;
    end
end

fprintf('Substimulus times: %s\n',sprintf('%d ',onsets))
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
