% Test WNOriDetectRandomization
% AE 2012-11-26

params.nSeeds = 5;
params.signals = [-45 45];
params.biases = [0 : 4; 4 : -1 : 0];
params.coherences = 1 : 5;
params.nCatchPerBlock = 10;
params.nRepsPerBlock = 5;
params.subBlockSize = 10;

rnd = WNOriDetectRandomization;
rnd = init(rnd, params);

% Simulate experiment
nBlocks = 10;
blockSize = params.nRepsPerBlock * numel(params.coherences) * sum(params.biases(:, 1)) + params.nCatchPerBlock;
nCorrect = nBlocks * blockSize;
nTrials = round(1.1 * nCorrect);
r = randperm(nTrials);
v = false(1, nTrials);
v(r(1 : nCorrect)) = true;
cond = zeros(1, nTrials);
for i = 1 : nTrials
    [rnd, cond(i)] = getNextTrial(rnd);
    rnd = trialCompleted(rnd, v(i));
end


%% Verify correct blocking
c = getConditions(rnd);
seed = [c(cond(v)).seed];
coh = [c(cond(v)).coherence];
signal = [c(cond(v)).signal];

% check signals
nSignal = [];
for i = 1 : nBlocks
    ndx = (i - 1) * blockSize + (1 : blockSize);
    h = histc(signal(ndx), unique(signal(~isnan(signal))));
    h(end + 1) = sum(isnan(signal(ndx)));
    nSignal(:, i) = h;
end
nSignal

% check seeds
figure(1), clf
for i = 1 : nBlocks
    ndx = (i - 1) * blockSize + (1 : blockSize);
    subplot(nBlocks, 1, i)
    h = histc(seed(ndx), unique(seed));
    plot(h, '-*k')
    axis tight
    xlim([0.5 params.nSeeds + 0.5])
end

% check coherences
figure(2), clf
for i = 1 : nBlocks
    ndx = (i - 1) * blockSize + (1 : blockSize);
    subplot(nBlocks, 1, i)
    h1 = histc(coh(ndx(signal(ndx) == params.signals(1))), unique(coh(~isnan(coh))));
    h2 = histc(coh(ndx(signal(ndx) == params.signals(2))), unique(coh(~isnan(coh))));
    plot(h1, '-*k'), hold on
    plot(h2, '-sr')
    axis([0.5, numel(params.coherences) + 0.5, min([h1 h2]) - 2, max([h1 h2]) + 2])
end

