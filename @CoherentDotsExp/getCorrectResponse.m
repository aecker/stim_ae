function e = getCorrectResponse(e)
% Send correct response to the state system.
% In this case: 0 = 1st color, 1 = 2nd color

% LabView accepts 0 (left) and 1 (right) as lever positions
curIndex = get(e,'curIndex');
correctResponse = curIndex.direction - 1;
pnet(get(e,'con'),'write',uint8(correctResponse));
