function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Start trial.
% AE 2011-02-18 & MS 2011-02-19

% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% determine condition to show
r = get(e,'randomization');
level = getLevel(r);
stepSize = getParam(e,'stepSize');
signalFraction = 1 / (1 + exp(-level * stepSize));
e = setTrialParam(e,'signalFraction',signalFraction);
e = setTrialParam(e,'level',level);
e = setTrialParam(e,'threshold',getThreshold(r));
% centerOrientation = getParam(e,'centerOrientation');

% determine orientation for this trial
if getParam(e,'classOverride')
    class = double(getParam(e,'classShown'));
else
    signal = getParam(e,'signal');
    signals = sort(getParam(e,'signals'));
% Follow Open-GL angle convention - angle increases clockwise.
%     if centerOrientation <=180
%         class = (centerOrientation-signal)>0;
%     else 
%         class = (centerOrientation-signal)<0;
%     end

% Use right target for smaller angle and left target for larger angle.
% Labview takes class = 0 as left and class = 1 as right.
class = signals(1)==signal;
end

% target overrides?
if getParam(e,'correctTargetOnly')
    if class
        leftTarget = getParam(e,'leftTarget');
        rightTarget = -1e10 * [1; 1];
    else
        leftTarget = -1e10 * [1; 1];
        rightTarget = getParam(e,'rightTarget');
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

% Set the delay time to include the post stimulus time 
delayTime = getParam(e,'stimulusTime') + getParam(e,'postStimulusTime');
e = setTrialParam(e,'delayTime',delayTime);

% Send the params that the state system needs
retStruct.delayTime = delayTime;
retStruct.punishTime = int32(punishTime);
retStruct.leftTarget = leftTarget;
retStruct.rightTarget = rightTarget;
retStruct.targetRadius = getParam(e,'targetRadius');
retStruct.correctResponse = int32(class);
