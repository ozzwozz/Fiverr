clear; clc;
disp('Program started');
% ff = load('C:\trs\ws_emor\emor_trs-master\y-asti\csvF\s1a_16_transformed.csv');
% laod files into matlab workspace
time = load('s1a_16_2.csv');
thing = load('move4_1.svo.csv');

% get size of matrix for use
[rows, cols] = size(thing);
checkff = ismissing(thing);
ff = zeros(rows, cols);
checkff
for i=1:rows
    for x=1:cols
        if checkff(i, x) == 0
            ff(i, x) = thing(i, x);
        end
    end
end
ff
% FORMULA  angle = arccos[(xa * xb + ya * yb + za * zb) / (?(xa2 + ya2 + za2) * ?(xb2 + yb2 + zb2))]

sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
clientID = -1;
while clientID < 0
    clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5); % open connection to coppeliasim
end
% send data to coppeliasim to show connection
sim.simxAddStatusbarMessage(clientID,'Hello CoppeliaSim!', sim.simx_opmode_oneshot);

%% Get Joint Handles from Coppeliasim in a blocking fashion, the code can't run without them
[~, neck_handle] = sim.simxGetObjectHandle(clientID,'neckJoint1', sim.simx_opmode_blocking);
[~, nose_handle] = sim.simxGetObjectHandle(clientID,'neckJoint0', sim.simx_opmode_blocking);
[~, Lshoulder_handle] = sim.simxGetObjectHandle(clientID,'leftArmJoint0', sim.simx_opmode_blocking);
[~,Lelbow_handle] = sim.simxGetObjectHandle(clientID,'leftArmJoint2', sim.simx_opmode_blocking);
[~,Rshoulder_handle] = sim.simxGetObjectHandle(clientID,'rightArmJoint0', sim.simx_opmode_blocking);
[~,Relbow_handle] = sim.simxGetObjectHandle(clientID,'rightArmJoint2', sim.simx_opmode_blocking);

[~,Lhip_handley] = sim.simxGetObjectHandle(clientID,'leftLegJoint1', sim.simx_opmode_blocking);
[~,Rhip_handley] = sim.simxGetObjectHandle(clientID,'rightLegJoint1', sim.simx_opmode_blocking);

[~,Lhip_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint2', sim.simx_opmode_blocking);
[~,Lknee_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint3', sim.simx_opmode_blocking);
[~,Lankle_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint5', sim.simx_opmode_blocking);
[~,Rhip_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint2', sim.simx_opmode_blocking);
[~,Rknee_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint3', sim.simx_opmode_blocking);
[~,Rankle_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint5', sim.simx_opmode_blocking);

% for all rows in the vector matrix
for i=1:rows
    %% Get Vector locations from csv
    Nose_Vector = [ff(i, 2), ff(i, 3), ff(i, 4)];
    Neck_Vector = ff(i, 5:7);
    
    RShoulder_Vector = ff(i, 8:10);
    RElbow_Vector = ff(i, 11:13);
    RWrist_Vector = ff(i, 14:16);
    
    LShoulder_Vector = ff(i, 17:19);
    LElbow_Vector = ff(i, 20:22);
    LWrist_Vector = ff(i, 23:25);
    
    RHip_Vector = ff(i, 26:28);
    RKnee_Vector = ff(i, 29:31);
    RAnkle_Vector = ff(i, 32:34);
        
    LHip_Vector = ff(i, 35:37);
    LKnee_Vector = ff(i, 38:40);
    LAnkle_Vector = ff(i, 41:43);
    
    REye_Vector = ff(i, 44:46);
    LEye_Vector = ff(i, 47:49);
    REar_Vector = ff(i, 50:52);
    LEar_Vector = ff(i, 53:55);
    

    %% Send position to coppeliasim
    sim.simxPauseCommunication(clientID,1);
    
    sim.simxSetObjectPosition (clientID, neck_handle, -1 , Neck_Vector, sim.simx_opmode_oneshot);
    
    sim.simxSetObjectPosition (clientID, Rshoulder_handle, sim.sim_handle_parent , RShoulder_Vector, sim.simx_opmode_oneshot);
    sim.simxSetObjectPosition (clientID, Lshoulder_handle, sim.sim_handle_parent , LShoulder_Vector, sim.simx_opmode_oneshot);

    sim.simxSetObjectPosition (clientID, Relbow_handle, sim.sim_handle_parent , RElbow_Vector, sim.simx_opmode_oneshot);
    sim.simxSetObjectPosition (clientID, Lelbow_handle, sim.sim_handle_parent , LElbow_Vector, sim.simx_opmode_oneshot);

    sim.simxSetObjectPosition (clientID, Rhip_handle, sim.sim_handle_parent , RHip_Vector, sim.simx_opmode_oneshot);
    sim.simxSetObjectPosition (clientID, Lhip_handle, sim.sim_handle_parent , LHip_Vector, sim.simx_opmode_oneshot);
    
    sim.simxSetObjectPosition (clientID, Rknee_handle, sim.sim_handle_parent , RKnee_Vector, sim.simx_opmode_oneshot);
    sim.simxSetObjectPosition (clientID, Lknee_handle, sim.sim_handle_parent , LKnee_Vector, sim.simx_opmode_oneshot);

    sim.simxSetObjectPosition (clientID, Rankle_handle, sim.sim_handle_parent , RAnkle_Vector, sim.simx_opmode_oneshot);
    sim.simxSetObjectPosition (clientID, Lankle_handle, sim.sim_handle_parent , LAnkle_Vector, sim.simx_opmode_oneshot);
    
    sim.simxPauseCommunication(clientID,0);     
end
