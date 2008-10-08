function reward = getReward(r,correct)

cond = r.conditionPool(r.currentTrial);
reward = correct && ...
    r.conditions(cond).trialType == FleHumanRandomization.REGULAR_REWARD;
