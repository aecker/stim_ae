function e = setParam(e)

e.TrialBasedExperiment = setParam(e.TrialBasedExperiment);
e = generateGaborTextures(e);
e = loadImageTextures(e);