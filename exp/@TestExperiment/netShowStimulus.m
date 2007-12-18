function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show stimulus.
% AE 2007-10-17

retStruct.correctResponse = TrialBasedExperiment.RIGHT_JOYSTICK;
retStruct.trialIndex = int32(getParam(e,'trialIndex'));
retStruct.trialType = int32(getParam(e,'trialType'));
retStruct.blockSize = int32(getParam(e,'blockSize'));
retStruct.blockType = int32(getParam(e,'blockType'));
tcpReturnFunctionCall(e,int32(0),retStruct);

% we simply keep swapping the buffers at random times
nFrames = get(e,'refreshRate') * getParam(e,'delayTime') / 1000;
t = zeros(2,nFrames);
for i = 1:nFrames
    WaitSecs(rand(1) * 0.009);
    t(1,i) = GetSecs;
    e = swap(e);
    t(2,i) = GetSecs;
end

% save times
e = setTrialParam(e,'extraTimes',t);

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
