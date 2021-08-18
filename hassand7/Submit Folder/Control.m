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

    [returncode, TargetHandle] = sim.simxGetObjectHandle(clientID,'Quadricopter_target', sim.simx_opmode_blocking);
    disp(returncode);
    [returncode, CopterHandle] = sim.simxGetObjectHandle(clientID, 'Quadricopter_base', sim.simx_opmode_blocking);
    disp(returncode);
    [returncode, heliHandle] = sim.simxGetObjectHandle(clientID, 'Quadricopter', sim.simx_opmode_blocking);
    disp(returncode);

    disp('he he');        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [~, targetPos] = sim.simxGetObjectPosition(clientID,TargetHandle,-1,sim.simx_opmode_streaming );
        
        %% vertical control
        [~, pos] = sim.simxGetObjectPosition(clientID, CopterHandle, -1, sim.simx_opmode_streaming );
        [returncode, LinearVelocity, AngularVelocity] = sim.simxGetObjectVelocity(clientID, heliHandle, sim.simx_opmode_streaming );
        e=targetPos(3)-pos(3);
        cumul=cumul+e;
        pv=pParam*e;
        thrust=5.335+pv+iParam*cumul+dParam*(e-lastE)+LinearVelocity(3)*vParam;
        lastE=e;
        
        %% Horizontal Control
        [~, sp] =sim.simxGetObjectPosition(clientID,TargetHandle, CopterHandle, sim.simx_opmode_streaming );
       % m=sim.simxGetObjectMatrix(clientID, CopterHandle,-1, sim.simx_opmode_blocking);
        [~, EulerAngles] = sim.simxGetObjectOrientation(clientID,CopterHandle, -1, sim.simx_opmode_streaming);
        
        
        [res, retInts, retFloats, retStrings, retBuffer]=sim.simxCallScriptFunction(clientID,'Quadricopter', sim.sim_scripttype_childscript,'robotMatrixCalc',[],[],[],[],sim.simx_opmode_blocking);
                
%         m = retFloats;
        m(1,1) = retFloats(1);
        m(1,2) = retFloats(2);
        m(1,3) = retFloats(3);
        m(1,4) = retFloats(4);
        m(2,1) = retFloats(5);
        m(2,2) = retFloats(6);
        m(2,3) = retFloats(7);
        m(2,4) = retFloats(8);
        m(3,1) = retFloats(9);
        m(3,2) = retFloats(10);
        m(3,3) = retFloats(11);
        m(3,4) = retFloats(12);
        vx=[1;0;0];
        vx=m.*vx;
        vy=[0;1;0];
        vy=m.*vy;
         
        alphaE=(vy(3)-m(12));
        alphaCorr=0.25*alphaE+2.1*(alphaE-pAlphaE);
        betaE=(vx(3)-m(12));
        betaCorr=-0.25*betaE-2.1*(betaE-pBetaE);
        pAlphaE=alphaE;
        pBetaE=betaE;        
        
        alphaCorr=alphaCorr+(sp(2)*0.005+1)*(sp(2)-psp2);
        betaCorr=betaCorr-(sp(1)*0.005-1)*(sp(1)-psp1);
        
        psp2=sp(2);
        psp1=sp(1);
    
        %% Rotational Control
        [~, euler]=sim.simxGetObjectOrientation(clientID, CopterHandle, TargetHandle, sim.simx_opmode_streaming);
        rotCorr=euler(3)*0.1+2*(euler(3)-prevEuler);
        prevEuler=euler(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %while simRemoteApi.status()% while sim running
    while 1
        [~, targetPos] = sim.simxGetObjectPosition(clientID,TargetHandle,-1,sim.simx_opmode_blocking );
        
        %% vertical control
        [~, pos] = sim.simxGetObjectPosition(clientID, CopterHandle, -1, sim.simx_opmode_blocking );
        [returncode, LinearVelocity, AngularVelocity] = sim.simxGetObjectVelocity(clientID, heliHandle, sim.simx_opmode_blocking );
        e=targetPos(3)-pos(3);
        cumul=cumul+e;
        pv=pParam*e;
        thrust=5.335+pv+iParam*cumul+dParam*(e-lastE)+LinearVelocity(3)*vParam;
        lastE=e;
        
        %% Horizontal Control
        [~, sp] =sim.simxGetObjectPosition(clientID,TargetHandle, CopterHandle, sim.simx_opmode_blocking );
       % m=sim.simxGetObjectMatrix(clientID, CopterHandle,-1, sim.simx_opmode_blocking);
        [~, EulerAngles] = sim.simxGetObjectOrientation(clientID,CopterHandle, -1, sim.simx_opmode_blocking);
        
        
        [res, retInts, retFloats, retStrings, retBuffer]=sim.simxCallScriptFunction(clientID,'Quadricopter', sim.sim_scripttype_childscript,'robotMatrixCalc',[],[],[],[],sim.simx_opmode_oneshot_wait);
                
        m(1,1) = retFloats(1);
        m(1,2) = retFloats(2);
        m(1,3) = retFloats(3);
        m(1,4) = retFloats(4);
        m(2,1) = retFloats(5);
        m(2,2) = retFloats(6);
        m(2,3) = retFloats(7);
        m(2,4) = retFloats(8);
        m(3,1) = retFloats(9);
        m(3,2) = retFloats(10);
        m(3,3) = retFloats(11);
        m(3,4) = retFloats(12);
        vx=[1;0;0];
        vx=m.*vx;
        vy=[0;1;0];
        vy=m.*vy;
         
        alphaE=vy(2, 3)-m(12);
        alphaCorr=0.25*alphaE+2.1*(alphaE-pAlphaE); % y correction
        betaE=(vx(1, 3)-m(12));
        betaCorr=-0.25*betaE-2.1*(betaE-pBetaE); % x correction
        pAlphaE=alphaE;
        pBetaE=betaE;        
        
        alphaCorr=alphaCorr+(sp(2)*0.005+1)*(sp(2)-psp2);
        betaCorr=betaCorr-(sp(1)*0.005-1)*(sp(1)-psp1);
        
        psp2=sp(2);
        psp1=sp(1);
    
        %% Rotational Control
        [~, euler]=sim.simxGetObjectOrientation(clientID, CopterHandle, TargetHandle, sim.simx_opmode_blocking);
        rotCorr=euler(3)*0.1+2*(euler(3)-prevEuler);
        prevEuler=euler(3);
        
        %% Send Velocities To V-rep
        %Decide of the motor velocities:
        
        particlesTargetVelocities(1) = thrust*(1-alphaCorr+betaCorr+rotCorr);
        particlesTargetVelocities(2) = thrust*(1-alphaCorr-betaCorr-rotCorr);
        particlesTargetVelocities(3) = thrust*(1+alphaCorr-betaCorr+rotCorr);
        particlesTargetVelocities(4) = thrust*(1+alphaCorr+betaCorr-rotCorr);
%         particlesTargetVelocities(1) = thrust*(1-alphaCorr+betaCorr);
%         particlesTargetVelocities(2) = thrust*(1-alphaCorr-betaCorr);
%         particlesTargetVelocities(3) = thrust*(1+alphaCorr-betaCorr);
%         particlesTargetVelocities(4) = thrust*(1+alphaCorr+betaCorr);
        particlesTargetVelocities;
        %SimulationParameter(propellerScripts[i],'particleVelocity',particlesTargetVelocities[i]); % script for paramter, paramter name, calculated velocities
        [~,~,~,~,~] = sim.simxCallScriptFunction(clientID,'Quadricopter', sim.sim_scripttype_childscript, 'setVelocities', 0, particlesTargetVelocities, 0, 0, sim.simx_opmode_blocking );
    end

