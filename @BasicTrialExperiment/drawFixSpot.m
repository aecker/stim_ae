function drawFixSpot(e,color)
% Draws a fixation spot.
% This function only draws into the back buffer and does not flip!

% if color is passed use thisd instead of currentParam.fixSpotColor
if ~exist('color','var')
    color = e.curParams.fixSpotColor;
end

win = get(e,'win');
rect = Screen('Rect',win);
halfWidth = ceil(diff(rect([1 3])) / 2);
halfHeight = ceil(diff(rect([2 4])) / 2);
x = halfWidth + e.curParams.fixSpotLocation(1);
y = halfHeight + e.curParams.fixSpotLocation(2);
Screen('glPoint', win,color,x,y,e.curParams.fixSpotSize);
