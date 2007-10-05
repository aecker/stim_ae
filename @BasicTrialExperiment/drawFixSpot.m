function drawFixSpot(e)
% Draws a fixation spot.
% This function only draws into the back buffer and does not flip!

win = get(e,'win');
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
x = halfWidth + e.curParams.fixSpotLocation(1);
y = halfHeight + e.curParams.fixSpotLocation(2);
Screen('glPoint', win,e.curParams.fixSpotColor,x,y,e.curParams.fixSpotSize);
