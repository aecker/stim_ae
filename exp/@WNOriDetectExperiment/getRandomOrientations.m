function ori = getRandomOrientations(e, n, seed)
% Get pseudorandom orientation sequence.
% AE 2012-11-27

% fix random number generator seed
if nargin > 2
    state = rand('state');                                      %#ok<*RAND>
    rand('state', seed)
end

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

% restore random number generator seed
if nargin > 2
    rand('state', state)
end
