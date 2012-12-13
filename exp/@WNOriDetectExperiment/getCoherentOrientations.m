function ori = getCoherentOrientations(e, n, signal, coherence)
% Get coherent orientation sequence.
% AE 2012-11-27

orientations = getParam(e, 'orientations');
orientations = setdiff(orientations, signal);
nOri = numel(orientations);

% random orientations (blocked so every orientation is shown before they
% repeat)
randori = zeros(1, n - coherence);
i = 0;
while i < n - coherence
    k = min(nOri, n - coherence - i);
    r = randperm(nOri);
    randori(i + (1 : k)) = orientations(r(1 : k));
    i = i + k;
end

% random frames allocated to signal
r = randperm(n);
ori(r(1 : coherence)) = signal;
ori(sort(r(coherence + 1 : n))) = randori;
