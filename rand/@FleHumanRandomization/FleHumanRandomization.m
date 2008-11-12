function r = FleHumanRandomization(maxBlockSize,speeds,barColors,directions,flashOffsets,flashLoc,offsetThresh)
% Human Flash-lag experiment randomizaton.
%   r = FleHumanRandomization(maxBlockSize,speeds,barColors,directions,flashOffsets,flashLoc,offsetThresh)
%
% AE & PhB 2008-10-08

r.conditionPool = [];
r.currentTrial = 0;
r.allConditions = [];
r.conditions = [];
r.firstCond = [];
r.maxBlockSize = maxBlockSize;
r.block = BlockRandomization;
sup = abs(flashOffsets) >= offsetThresh;
% sup = flashOffsets >= offsetThresh;     % stupid bug...
r.supraParams = struct('speed',speeds,'barColor',barColors,'direction',directions,'flashOffset',flashOffsets(sup),'flashLocation',flashLoc);
r.subParams = struct('speed',speeds,'barColor',barColors,'direction',directions,'flashOffset',flashOffsets(~sup),'flashLocation',flashLoc);

r = class(r,'FleHumanRandomization');
