function r = FlePhysEffRandomization(barColor,trajectoryAngle,dx, ...
    direction,numFlashLocs,flashStop,arrangement,combined)

% internal white noise randomization
r.white = [];
r.conditions = [];
r.whiteBackup = [];      % to put back one condition we didn't use

% parameters
r.barColor = barColor;
r.trajectoryAngle = trajectoryAngle;
r.dx = dx;
r.direction = direction;
r.numFlashLocs = numFlashLocs;
r.flashStop = flashStop;
r.arrangement = arrangement;
r.combined = combined;

r = class(r,'FlePhysEffRandomization');
