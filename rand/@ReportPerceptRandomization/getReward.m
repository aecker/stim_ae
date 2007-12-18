function reward = getReward(r,correct)

cond = r.conditionPool(r.currentTrial);
reward = correct && ...
    r.conditions(cond).trialType == ReportPerceptRandomization.REGULAR_REWARD;
