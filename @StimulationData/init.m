function data = init(data,expType,constants,conditions,perTrial)
% Initialize StimulationData object.
%    This should be done at startSession when all parameters, their values, and
%    the different conditions are known.
%
% AE 2007-10-01

% constants
data.params.constants.expType = expType;
data.params.constants.startTime = now;
data.params.constants = parseVarArgs(data.constants,constants{:});
% make sure subject name is present
if isempty(data.constant.subject)
    error('StimulationData:init','Constant ''subject'' missing!')
end

data.params.conditions = conditions;
data.params.trials = parseVarArgs(struct('condition',[]),perTrial{:});

% create directory for temporary storage of trial data
subject = data.constants.subject;
date = datestr(data.constants.startTime,'YYYY-mm-dd HH-MM-SS');
data.folder = getLocalPath(sprintf('/stor01/stimulation/%s/%s',subject,date));
data.fallback = sprintf('~/stimulation/%s',date);
mkdir(data.fallback)

% save parameters to disk
saveData(data);

% mark as initialized
data.initizalized = true;
