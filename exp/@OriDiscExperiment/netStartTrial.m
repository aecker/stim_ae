function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2010-10-24

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% determine orientation for this trial
if getParam(e,'classOverride')
    class = double(getParam(e,'classShown'));
else
    class = getParam(e,'class');
end
stepSize = getParam(e,'stepSize');
r = get(e,'randomization');
level = getLevel(r);
centerOri = getParam(e,'centerOrientation');
orientation = centerOri + (2 * class - 1) * 2.^(stepSize * level);
e = setTrialParam(e,'orientation',orientation);
e = setTrialParam(e,'level',level);
e = setTrialParam(e,'threshold',getThreshold(r));

% if phases are supposed to be randomized, determine the phase for this
% trial here (note that this is not blocked in any way)
if getParam(e,'randPhase')
    phase = rand(1) * 360;
else
    phase = 0;
end
e = setTrialParam(e,'phase',phase);

% target overrides?
if getParam(e,'correctTargetOnly')
    if class
        leftTarget = -1e10 * [1; 1];
        rightTarget = getParam(e,'rightTarget');
    else
        leftTarget = getParam(e,'leftTarget');
        rightTarget = -1e10 * [1; 1];
    end        
else
    leftTarget = getParam(e,'leftTarget');
    rightTarget = getParam(e,'rightTarget');
end

% Punish according to user specification
inCorrectResponse = ~(getParam(e,'correctResponse'));
validTrial = getParam(e,'validTrial');
punishTime = 0;
switch params.punishType
    case 'IncorrRespOnly'
        if validTrial && inCorrectResponse
            punishTime = params.punishTime;
        end
    case 'AbortsOnly'
        if ~validTrial
            punishTime = params.punishTime;
        end
    otherwise % aborts and incorrect response
        if ~validTrial || inCorrectResponse
            punishTime = params.punishTime;
        end
end

retStruct.punishTime = int32(punishTime);

% inform state system of response targets
retStruct.leftTarget = leftTarget;
retStruct.rightTarget = rightTarget;
retStruct.targetRadius = getParam(e,'targetRadius');
retStruct.correctResponse = class;

