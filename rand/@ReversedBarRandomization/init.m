function r = init(r,params)
% Initialize randomization.
% AE & PhB 2007-10-09

% make sure initMapTrials is set
if isnan(r.initMapTrials) || isnan(r.exceptionRate)
    error('Parameters initMapTrials and exceptionRate have to be set!')
end

% compute number of normal trials in each direction
nExceptions = length(params.exceptionTypes);
nLocations = length(params.exceptionLocations);
r.nNormalTrials = (nExceptions * nLocations * 2) / ...
    (r.exceptionRate / (1 - r.exceptionRate));
r.nNormalTrials = ceil(r.nNormalTrials / 2);

r = computeConditions(r,params);
r = resetPool(r);
