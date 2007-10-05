function showCircle(locationVector,radius,duration)
% SHOWCIRCLE(locationVector,radius,duration) shows a circle of given radius at a given location on the
% screen. locationVector = [x y] = [0 0] corresponds to screen center.
% Duration is given in milliSecs.
%
%
% Mani 06-Sep-2007
x = locationVector(1);
y = locationVector(2);

win = e.win;
params = get(e,'params');
% converting the given Cartesian coordinates to screen coordinates
rect = Screen('Rect',win);
xc = round(rect(3)/2); % center of screen
yc = round(rect(4)/2); % center of screen

xs = xc+x;
ys = yc-y;

%show a red filled circle at the given location
Screen('glPoint',win,[255 0 0],xs,ys,radius)
T = GetSecs;
endTime = Inf;
firstFlip = true;
while T < endTime
    if firstFlip 
        vbl = Screen('Flip',win);
        endTime = vbl+duration/1000;
    end
    T = GetSecs;
end

Screen('FillRect', win, params.bgColor);
Screen('Flip',win);

    
    






