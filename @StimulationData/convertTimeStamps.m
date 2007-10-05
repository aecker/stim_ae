function data = convertTimeStamps(data)
% Convert local timestamps to state system time.
%    We are using a sliding window to compute an average offset between the
%    two clocks.
%
% AE 2007-02-22

% sync = [data.curTrial.sync];
% macTimes = ([sync.start] + [sync.end]) / 2;
% labViewTimes = [sync.response];
% offsets = macTimes - labViewTimes;

% winSize = 101;
% if length(offsets) < winSize
%     offsets = repmat(mean(offsets),size(offsets));
% else
%     win = window(@gausswin,101);
%     win = win / sum(win);
%     f = conv(offsets,win);
%     w2 = fix(winSize/2);
%     f = f(w2+1:end-w2);
%     f(1:w2) = f(w2+1);
%     f(end-w2+1:end) = f(end-w2);
%     offsets = f;
% end
