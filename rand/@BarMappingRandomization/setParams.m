function r = setParams(r,params)

r.params = params;

% recreate WhiteNoiseRandomizations
cond = getConditions(r.block);
for i = 1:length(cond)
    r.white(i) = setParams(r.white(i),params);
end
