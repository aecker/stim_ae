function r = init(r,params)
% AE & MS 2008-07-17

% initialize BlockRandomization with allBarAngles only (e.g. colors are
% randomized by the WhiteNoiseRandomization)
r.block = init(BlockRandomization,struct('barAngle',params.barAngle));

% create WhiteNoiseRandomizations
cond = getConditions(r.block);
for i = 1:length(cond)
    r.white(i) = setParams(WhiteNoiseRandomization,r.params);
end
