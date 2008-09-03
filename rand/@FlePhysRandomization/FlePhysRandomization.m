function r = FlePhysRandomization(barColor,trajectoryAngle,dx,direction,numFlashLocs)

% internal block randomization
r.block = [];
r.conditions = [];

% parameters
r.barColor = barColor;
r.trajectoryAngle = trajectoryAngle;
r.dx = dx;
r.direction = direction;
r.numFlashLocs = numFlashLocs;

r = class(r,'FlePhysRandomization');
