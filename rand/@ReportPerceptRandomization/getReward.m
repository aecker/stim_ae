function reward = getReward(r,correct)

cond = r.conditionPool(r.currentTrial);
reward = correct && r.conditions(cond).trialType == REGULAR_REWARD(r);
