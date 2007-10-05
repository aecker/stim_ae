function e = init(e)
% Initialize experiment.
% AE 2007-10-04

% initalize sounds
e = initSounds(e);

% extract different parameter types and initialize StimulationData
const = (e.paramTypes == getParamTypeConstant(e,'constant'));
trials = (e.paramTypes == getParamTypeConstant(e,'trial'));
conditions = getConditions(e.randomization);
e.data = init(e.data,class(e),e.paramNames(const),conditions,e.paramNames(trials));
