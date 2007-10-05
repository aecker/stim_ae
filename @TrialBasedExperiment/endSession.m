function e = endSession(e)
% Finalize session, i.e. write data to disk.
% AE 2007-002-22

% Get session date and subject
con = get(e,'con');
subject = pnet(con,'readline');
date = pnet(con,'readline');

% Store conditions
c = getConditions(e.randomization);
paramNames = fieldnames(e.params);
[m,n] = size(c);
for i = 1:m
    for j = 1:n
        conditions(i).(paramNames{j}) = e.params.(paramNames{j})(c(i,j));
    end
end

% Convert local timestamps to state system time
e.data = convertTimeStamps(e.data);

% write data to disk
saveData(e.data,class(e),subject,date,'conditions',conditions);
