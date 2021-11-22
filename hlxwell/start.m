    global sim;
    global clientID;
    sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    sim.simxFinish(-1); % just in case, close all opened connections
    clientID = -1;
    
    % open connection to MATLAB
    while clientID < 0
        clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5); % open connection to coppeliasim
    end
    % send data to coppeliasim to show connection
    sim.simxAddStatusbarMessage(clientID,'Hello CoppeliaSim!', sim.simx_opmode_oneshot);
    varargout = GUI(0);
