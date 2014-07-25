function ori = getRandomOrientations(e, n)
% Get pseudorandom orientation sequence.
% AE 2012-11-27

% draw pseudorandom sequence (orientations are blocked such that they don't
% repeat until each one has been shown once)
orientations = getParam(e, 'orientations');
nOri = numel(orientations);
ori = zeros(1, n);
i = 0;
while i < n
    k = min(nOri, n - i);
    r = randperm(nOri);
    ori(i + (1 : k)) = orientations(r(1 : k));
    i = i + k;
end
