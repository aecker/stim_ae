function r = FlePhysRandomization(barColor,trajectoryAngle,dx,direction,numFlashLocs,flashStop)

% internal block randomization
r.block = [];
r.conditions = [];

% parameters
r.barColor = barColor;
r.trajectoryAngle = trajectoryAngle;
r.dx = dx;
r.direction = direction;
r.numFlashLocs = numFlashLocs;
r.flashStop = flashStop;

r = class(r,'FlePhysRandomization');
