function e = getCurrentParam(e)
% Query current parameters.
%    This function is used by the labView state system to get the 
%    parameters used in the current trial.
%
% AE 2007-02-21

% get connection handle
con = get(e,'con');

% Read parameter names:
%   LabView is sending a list of parameter names whose values it needs to
%   know. These parameter names are separated by spaces
params = pnet(con,'readline');
params = textscan(params,'%s');

% send actual values
for i = 1:length(params)
    % Write back values of the parameter queried in the order in which the
    %   parameters appear in the list above
    pnet(con,'write',e.curParams.(params{1}{i}));
end


