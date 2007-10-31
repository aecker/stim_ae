function testGratingExperiment
% Debugging script

% close old connections
pnet('closeall');

% connect
con = pnet('tcpconnect','localhost',1234);
fprintf('Connected\n')

% set some parameters
pnet(con,'printf','setParam\n');
pnet(con,'printf','stimTime numTrials\n');

pnet(con,'write',uint16(1));
pnet(con,'write',[2000]);

pnet(con,'write',uint16(1));
pnet(con,'write',[5]);

if pnet(con,'read',1,'uint8');
    fprintf('Parameters set\n')
end

% run some trials
endExp = false;
i = 1;
while ~endExp
    
    pnet(con,'printf','startTrial\n');
    fprintf('Trial %d ',i);

    pnet(con,'printf','showFixSpot\n');
    WaitSecs(rand(1)*1.5);
    
    pnet(con,'printf','putStateEvent\n');
    pnet(con,'printf','acquireFixation\n');
    pnet(con,'write',GetSecs*1000);
    t = rand(1)*0.3;
    WaitSecs(0.3-t);
    
    % abort with some probability
    if rand(1) > 0.8
        pnet(con,'printf','abortTrial\n');
        pnet(con,'printf','eyeAbort\n');
        pnet(con,'write',GetSecs*1000);
        fprintf('[eyeAbort during fixation]\n');
    else
    
        % show stimulus and give reward
        WaitSecs(t);
        pnet(con,'printf','showStimulus\n');

        % potential abort (here we put a lever abort)
        t = rand(1)*0.5;
        WaitSecs(0.5-t);
        if rand(1) > 0.8
            pnet(con,'printf','abortTrial\n');
            pnet(con,'printf','leverAbort\n');
            pnet(con,'write',GetSecs*1000);
            fprintf('[leverAbort during stimulus]\n');
        else

            pnet(con,'read',1,'uint8');

            pnet(con,'printf','putStateEvent\n');
            pnet(con,'printf','startReward\n');
            pnet(con,'write',GetSecs*1000);
            WaitSecs(0.05);

            pnet(con,'printf','putStateEvent\n');
            pnet(con,'printf','endReward\n');
            pnet(con,'write',GetSecs*1000);
            fprintf('[+]\n');
        end
    end
        
    WaitSecs(1.5)
    pnet(con,'printf','endTrial\n');
    endExp = pnet(con,'read',1,'uint8');
    i = i+1;
end
fprintf('\n')

% finalize session
pnet(con,'printf','endSession\n');
pnet(con,'printf','monkey2\n');
pnet(con,'printf','%s\n',datestr(now,'yyyy-mm-dd HH-MM-SS'));

% close connection
pnet(con,'close')
