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
    try
        if(iscell(e.curParams.(params{1}{i})))
            %If this is a bunch of cells containing strings, send them all
            %with space seperation, and a CRLF at the end
            
            if(ischar(e.curParams.(params{1}{i}){1}))
                towrite = [];
                for(j = 1:length(e.curParams.(params{1}{i})))
                    towrite = sprintf('%s%s ', towrite, e.curParams.(params{1}{i}){j});                    
                end
                towrite = sprintf('%s\r\n', towrite(1:end-1));
                pnet(con, 'write', towrite);
            end       
        else
            pnet(con,'write',e.curParams.(params{1}{i}));
        end
    catch
        disp(['Error with ' num2str(i) ' iteration - ' params{1}{i} ' value is ' e.curParams.(params{1}{i})]);
        e.curParams.(params{1}{i})
        pnet(con, 'write', [13 10]);
        lasterror
    end
end


