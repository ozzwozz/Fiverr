    clear; clc;
    pParam=2;
    iParam=0;
    dParam=0;
    vParam=-2;

    cumul=0;
    lastE=0;
    pAlphaE=0;
    pBetaE=0;
    psp2=0;
    psp1=0;

    m = zeros(3,4);
    prevEuler=0;
    sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
    sim.simxFinish(-1); % just in case, close all opened connections
    clientID = -1;
    while clientID < 0
        clientID = sim.simxStart('127.0.0.1',19999,true,true,5000,5);
    end
%     while 1
%         particlesTargetVelocities = [5,5,5,5];
%         [~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'Quadricopter', sim.sim_scripttype_childscript, 'setVelocities', 0, particlesTargetVelocities, 0, 0, sim.simx_opmode_blocking);
%     end
    particlesTargetVelocities=[0,0,0,0];

    disp('he he');        


    while 1
        %% Send Velocities To V-rep
        %Decide of the motor velocities:
        
        %SimulationParameter(propellerScripts[i],'particleVelocity',particlesTargetVelocities[i]); % script for paramter, paramter name, calculated velocities
        [~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'Quadricopter#0', sim.sim_scripttype_childscript, 'justdo', 0, 0, 0, 0, sim.simx_opmode_blocking );
        [~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'Quadricopter#0', sim.sim_scripttype_childscript, 'motorvel', 0, 0, 0, 0, sim.simx_opmode_blocking );

    end

