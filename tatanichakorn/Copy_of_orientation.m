clear; clc;
disp('Program started');
% ff = load('C:\trs\ws_emor\emor_trs-master\y-asti\csvF\s1a_16_transformed.csv');
% laod files into matlab workspace
time = load('s1a_16_2.csv');
ff = load('s1a_16.csv');
%ff = load('move4_1.svo.csv');

% get size of matrix for use
[rows, cols] = size(ff);
% checkff = ismissing(thing);
% ff = zeros(rows, cols);
% for i=1:rows
%     for x=1:cols
%         if checkff(i, x) == 0
%             ff(i, x) = thing(i, x);
%         end
%     end
% end
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
%% arms
[~, Lshoulder_handlex] = sim.simxGetObjectHandle(clientID,'leftArmJoint0', sim.simx_opmode_blocking);
[~, Lshoulder_handley] = sim.simxGetObjectHandle(clientID,'leftArmJoint1', sim.simx_opmode_blocking);
[~,Lelbow_handle] = sim.simxGetObjectHandle(clientID,'leftArmJoint2', sim.simx_opmode_blocking);

[~,Rshoulder_handlex] = sim.simxGetObjectHandle(clientID,'rightArmJoint0', sim.simx_opmode_blocking);
[~,Rshoulder_handley] = sim.simxGetObjectHandle(clientID,'rightArmJoint1', sim.simx_opmode_blocking);
[~,Relbow_handle] = sim.simxGetObjectHandle(clientID,'rightArmJoint2', sim.simx_opmode_blocking);

%% left right hip
[~,Rhip_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint0', sim.simx_opmode_blocking);
[~,Lhip_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint0', sim.simx_opmode_blocking);

[~,Rhip_handlex] = sim.simxGetObjectHandle(clientID,'rightLegJoint2', sim.simx_opmode_blocking);
[~,Lhip_handlex] = sim.simxGetObjectHandle(clientID,'leftLegJoint2', sim.simx_opmode_blocking);
[~,Rhip_handley] = sim.simxGetObjectHandle(clientID,'rightLegJoint1', sim.simx_opmode_blocking);
[~,Lhip_handley] = sim.simxGetObjectHandle(clientID,'leftLegJoint1', sim.simx_opmode_blocking);
[~,Rhip_handlez] = sim.simxGetObjectHandle(clientID,'rightLegJoint0', sim.simx_opmode_blocking);
[~,Lhip_handlez] = sim.simxGetObjectHandle(clientID,'leftLegJoint0', sim.simx_opmode_blocking);

%% left right knee & ankle
[~,Lknee_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint3', sim.simx_opmode_blocking);
[~,Lankle_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint5', sim.simx_opmode_blocking);
[~,Rknee_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint3', sim.simx_opmode_blocking);
[~,Rankle_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint5', sim.simx_opmode_blocking);

neckJointSphere_handle = sim.simxGetObjectHandle(clientID, 'neckJointSphere', sim.simx_opmode_blocking);
rightShoulder_handle = sim.simxGetObjectHandle(clientID, 'rightShoulder', sim.simx_opmode_blocking);
leftShoulder_handle = sim.simxGetObjectHandle(clientID, 'leftShoulder', sim.simx_opmode_blocking);
rightLegJointSphere0_handle = sim.simxGetObjectHandle(clientID, 'rightLegJointSphere0', sim.simx_opmode_blocking);
leftLegJointSphere0_handle = sim.simxGetObjectHandle(clientID, 'leftLegJointSphere0', sim.simx_opmode_blocking);

%% default orientation
[~, DO_Neck] = sim.simxGetObjectOrientation(clientID,neckJointSphere_handle,-1,sim.simx_opmode_blocking);
[~, DO_RShoulder] = sim.simxGetObjectOrientation(clientID,rightShoulder_handle,neckJointSphere_handle,sim.simx_opmode_blocking);
[~, DO_LShoulder] = sim.simxGetObjectOrientation(clientID,leftShoulder_handle,neckJointSphere_handle,sim.simx_opmode_blocking);
[~, DO_RLeg] = sim.simxGetObjectOrientation(clientID,rightLegJointSphere0_handle,neckJointSphere_handle,sim.simx_opmode_blocking);
[~, DO_LLeg] = sim.simxGetObjectOrientation(clientID,leftLegJointSphere0_handle,neckJointSphere_handle,sim.simx_opmode_blocking);

disp('here');

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
    
    
    %     %% Calculate target joinet angles
    A_Neck = atan2(Nose_Vector(1),Neck_Vector(1)) + DO_Neck(1);
    A_RShoulder_y = atan2(Neck_Vector(2),RShoulder_Vector(2)) + DO_RShoulder(2);
    A_RShoulder_x = atan2(Neck_Vector(1),RShoulder_Vector(1)) + DO_RShoulder(1);
    
    A_LShoulder_y = atan2(Neck_Vector(2),LShoulder_Vector(2)) + DO_LShoulder(2);
    A_LShoulder_x = atan2(Neck_Vector(1),LShoulder_Vector(1)) + DO_LShoulder(1);
    
    A_RElbow = atan2(RShoulder_Vector(1),RElbow_Vector(1)) + DO_LShoulder(1);
    A_LElbow = atan2(LShoulder_Vector(1),LElbow_Vector(1)) + DO_LShoulder(1);
    
    A_RHip_x = atan2(Neck_Vector(1),RHip_Vector(1)) + DO_RLeg(1);
    A_RHip_y = atan2(Neck_Vector(2),RHip_Vector(2)) + DO_RLeg(2);
    A_RHip_z = atan2(Neck_Vector(3),RHip_Vector(3)) + DO_RLeg(3);
    
    A_LHip_x = atan2(Neck_Vector(1),LHip_Vector(1)) + DO_LLeg(1);
    A_LHip_y = atan2(Neck_Vector(2),LHip_Vector(2)) + DO_LLeg(2);
    A_LHip_z = atan2(Neck_Vector(3),LHip_Vector(3)) + DO_LLeg(3);

    %A_RHip = atan2(norm(cross(Neck_Vector,RHip_Vector)), dot(Neck_Vector,RHip_Vector)) - DO_LLeg;
    %A_LHip = atan2(norm(cross(Neck_Vector,LHip_Vector)), dot(Neck_Vector,LHip_Vector)) - DO_LLeg;
    A_Rknee = atan2(RHip_Vector(1),RKnee_Vector(1)) + DO_RLeg(1);
    A_Lknee = atan2(LHip_Vector(1),LKnee_Vector(1)) + DO_LLeg(1);
    
    A_RFoot = -atan2(RKnee_Vector(1),RAnkle_Vector(1)) + DO_RLeg(1);
    A_LFoot = -atan2(LKnee_Vector(1),LAnkle_Vector(1)) + DO_LLeg(1);
    
    %% Send joint angles to coppeliasim - pause the communication so that all angles are changed simultaneously
    sim.simxPauseCommunication(clientID,1);
    sim.simxSetJointTargetPosition(clientID, neck_handle, A_Neck, sim.simx_opmode_blocking);
    
    sim.simxSetJointTargetPosition(clientID, Rshoulder_handlex, A_RShoulder_x, sim.simx_opmode_blocking);
    sim.simxSetJointTargetPosition(clientID, Lshoulder_handlex, A_LShoulder_x, sim.simx_opmode_blocking);
    
    sim.simxSetJointTargetPosition(clientID, Rshoulder_handley, A_RShoulder_y, sim.simx_opmode_blocking);
    sim.simxSetJointTargetPosition(clientID, Lshoulder_handley, A_LShoulder_y, sim.simx_opmode_blocking);
    
    sim.simxSetJointTargetPosition(clientID, Relbow_handle, A_RElbow, sim.simx_opmode_blocking);
    sim.simxSetJointTargetPosition(clientID, Lelbow_handle, A_LElbow, sim.simx_opmode_blocking);
        
    sim.simxSetJointTargetPosition(clientID, Rknee_handle, A_Rknee, sim.simx_opmode_blocking);
    sim.simxSetJointTargetPosition(clientID, Lknee_handle, A_Lknee, sim.simx_opmode_blocking);
    
    sim.simxSetJointTargetPosition(clientID, Rankle_handle, A_RFoot, sim.simx_opmode_blocking);
    sim.simxSetJointTargetPosition(clientID, Lankle_handle, A_LFoot, sim.simx_opmode_blocking);
    
    %% TEST PUB
    %
    sim.simxSetJointTargetPosition(clientID, Rhip_handlex, A_RHip_x, sim.simx_opmode_blocking);
    %         sim.simxSetJointTargetPosition(clientID, Rhip_handley, A_RHip_y, sim.simx_opmode_blocking);
    %         sim.simxSetJointTargetPosition(clientID, Rhip_handlez, A_RHip_z, sim.simx_opmode_blocking);
    %
    sim.simxSetJointTargetPosition(clientID, Lhip_handlex, A_LHip_x, sim.simx_opmode_blocking);
    %         sim.simxSetJointTargetPosition(clientID, Lhip_handley, A_LHip_y, sim.simx_opmode_blocking);
    %         sim.simxSetJointTargetPosition(clientID, Lhip_handlez, A_LHip_z, sim.simx_opmode_blocking);
    
    sim.simxPauseCommunication(clientID,0);
    
    i
end
