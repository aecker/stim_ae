function r = FlePhysEffRandomization

% internal white noise randomization
r.white = [];
r.conditions = [];
r.whiteBackup = [];      % to put back one condition we didn't use

r = class(r,'FlePhysEffRandomization');
