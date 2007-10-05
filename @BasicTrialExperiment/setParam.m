function e = setParam(e)

% read parameter name
con = get(e,'con');
params = pnet(con,'readline');
params = textscan(params,'%s');
params = params{1};
success = true;

for i = 1:length(params)

	% Get the parameter type
	paramType = pnet(con,'read',1,'uint16');
	
	if(paramType == 1)  % Vector of doubles

        % read how many parameter values follow
        numVals = pnet(con,'read',1,'uint16');
        values = pnet(con,'read',numVals,'double');

        % we don't want to crash because of bad number values coming in through
        % the network.
        try

            % reshape vector
            values = reshape(values,e.paramSizes.(params{i}),[]);

            % put into parameter lists
            e.params.(params{i}) = values;

        catch 
            % display error caught
            err = lasterror;
            fprintf('Caught the following error in %s:\n%s\n\n','setParam',err.message);
            success = false;
        end
    elseif(paramType == 2) % String or array of strings
        
        values = pnet(con,'readline');
        values = textscan(values,'%s');
       
        % Save vector of cells, where cells contain strings
        e.params.(params{i}) = values{1};
    end
end

% send confirmation message if everything ok
if success
    pnet(con,'write',uint8(1));
else
    pnet(con,'write',uint8(0));
end

% Update randomization
paramNames = fieldnames(e.params);
nParams = length(paramNames);
nVals = zeros(1,nParams);
for i = 1:nParams
    nVals(i) = size(e.params.(paramNames{i}),2);
end 
e.randomization = feval(class(e.randomization),nVals,e.params.numTrials);

% reinitialize experiment
% (This function has to be implemented by any child of TrialBasedExperiment!)
e = init(e);
