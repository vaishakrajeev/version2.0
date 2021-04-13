function [NextObs,Reward, IsDone, LoggedSignals] = myStepFunction(Action, LoggedSignals)
%UNTITLED2 Summary of this function goes here
%   Custom Step function to construct MicroGrid for the
%   function
%   This function applies the given action to the environment and evaluates
%   the system dynamics for simulation step


%   Define the environment constants
deltat = 1;
Crate = 4;
Drate = -4;
%BLmax = 36; %Maximum energy level in KWh
%BLmin = 7.2; %Minimum energy level in KWh


%   Check if the given action is valid.
if ~ismember(Action,[-1, 0, 1])
    error('Action must be %g for charging and %g for idle and %g for discharging.',...
        -1,0,1);
end


%   Unpack the state vector from the logged signals.
State = LoggedSignals.State;
load = State(1);
pv = State(2);
wind = State(3);
soc = State(4);
time = State(5);

bprice = 2;
cprice = 2;

%Calculate PG(t)
u = Action*Crate;
PG = load - pv - wind + u;

load = randi(45,1);
pv = randi(38,1);
wind = randi(23,1);
time = time + 1;



% if(Action == 1)
%         soc = soc + deltat*Crate;
% end
% if(Action == -1)
%     soc = soc + deltat*Drate;
% end



%Check terminal condition
X = time;
IsDone = X>=24;



%Get Reward
if Action == 1
    if soc >= 80
        Reward = -10;
    else
        soc = soc + deltat*Crate;
        Reward = -PG*bprice;
    end
end
if Action == 0
    Reward = 0;
end
if Action == -1
    if soc <= 30
        Reward = -10;
    else
        soc = soc + deltat*Drate;
        Reward = PG*cprice;
    end
end

State =[load; pv; wind; soc; time];
LoggedSignals.State = State;

%Transform state to observation.
NextObs = soc;
        

end

