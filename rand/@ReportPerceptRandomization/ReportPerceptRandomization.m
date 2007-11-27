function r = ReportPerceptRandomization
% Randomization implementing a rewarding scheme to make the monkey report his
% percept.
%
% AE & PhB 2007-11-18

r.conditionPool = [];
r.currentTrial = 0;
r.conditions = [];
r.maxBlockSize = 3;
r.totalMaxBlockSize = r.maxBlockSize;
r.expMode = true;

r = class(r,'ReportPerceptRandomization');
