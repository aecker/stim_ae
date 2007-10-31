function e = getCorrectResponse(e)
% Send correct response to the state system.
% In this case: [0...180) = left, [180...360) = right

correctResponse = mod(e.curParams.direction,360) >= 180;
pnet(get(e,'con'),'write',uint8(correctResponse));
