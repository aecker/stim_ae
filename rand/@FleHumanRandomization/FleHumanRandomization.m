function r = FleHumanRandomization(maxBlockSize,speeds,barColors,directions,flashOffsets,offsetThresh)
% Human Flash-lag experiment randomizaton.
%   r = FleHumanRandomization(maxBlockSize,speeds,barColors,directions,flashOffsets,offsetThresh)
%
% AE & PhB 2008-10-08

r.conditionPool = [];
r.currentTrial = 0;
r.allConditions = [];
r.conditions = [];
r.firstCond = [];
r.maxBlockSize = maxBlockSize;
r.block = [];
sup = flashOffsets >= offsetThresh;
r.supraParams = struct('speed',speeds,'barColor',barColors,'direction',directions,'flashOffset',flashOffsets(sup));
r.subParams = struct('speed',speeds,'contrast',contrasts,'direction',directions,'flashOffset',flashOffsets(~sup));

r = class(r,'FleHumanRandomization');
