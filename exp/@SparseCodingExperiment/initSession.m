function e = initSession(e,params,expType)

% substract fixation time after stimulus is off to produce stimulus time.
% stimTime is used to control the behaviour of the netShowStimulus function.
params.stimulusTime = params.delayTime - params.postStimulusTime;

% initialize parent
e.TrialBasedExperiment = initSession(e.TrialBasedExperiment,params,expType);

% Since we overwrote initSession, we need to manually initialize the conditions 
% now. TrialBasedExperiment/initSession is calling initCondition automatically,
% but since the above call is running only on the parent, it calls
% TrialBasedExperiment/initCondition instead of GratingExperiment/initSession.

for i = 1:getNumConditions(e)
    e = initCondition(e,i);
end

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
