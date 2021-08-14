clear; clc;
disp('Program started');
% ff = load('C:\trs\ws_emor\emor_trs-master\y-asti\csvF\s1a_16_transformed.csv');
% laod files into matlab workspace
time = load('s1a_16_2.csv');
thing = load('s1a_16.csv');

% get size of matrix for use
[rows, cols] = size(thing);
checkff = ismissing(thing);
ff = zeros(rows, cols);
for i=1:rows
    for x=1:cols
        if checkff(i, x) == 0
            ff(i, x) = thing(i, x);
        end
    end
end
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
    
    %% Calculate target joinet angles
    A_Neck(i) = deg2rad(atan2(norm(cross(Nose_Vector,Neck_Vector)), dot(Nose_Vector,Neck_Vector)));
    A_RShoulder(i) = atan2(norm(cross(Neck_Vector,RShoulder_Vector)), dot(Neck_Vector,RShoulder_Vector));
    A_LShoulder(i) =atan2(norm(cross(Neck_Vector,LShoulder_Vector)), dot(Neck_Vector,LShoulder_Vector));
    
    A_RElbow(i) = atan2(norm(cross(RShoulder_Vector,RElbow_Vector)), dot(RShoulder_Vector,RElbow_Vector));
    A_LElbow(i) = atan2(norm(cross(LShoulder_Vector,LElbow_Vector)), dot(LShoulder_Vector,LElbow_Vector));
    
    A_RHip(i) = atan2(norm(cross(Neck_Vector,RHip_Vector)), dot(Neck_Vector,RHip_Vector));
    A_LHip(i) = atan2(norm(cross(Neck_Vector,LHip_Vector)), dot(Neck_Vector,LHip_Vector));
    
    A_Rknee(i) = atan2(norm(cross(RHip_Vector,RKnee_Vector)), dot(RHip_Vector,RKnee_Vector));
    A_Lknee(i) = atan2(norm(cross(LHip_Vector,LKnee_Vector)), dot(LHip_Vector,LKnee_Vector));
    
    A_RFoot(i) = -atan2(norm(cross(RKnee_Vector,RAnkle_Vector)), dot(RKnee_Vector,RAnkle_Vector));
    A_LFoot(i) = -atan2(norm(cross(LKnee_Vector,LAnkle_Vector)), dot(LKnee_Vector,LAnkle_Vector));
    
    %% unused as the astii does not have eyes and ears, would be used for centre of mass calculations with the head as counterweight
    A_REye = atan2d(norm(cross(Nose_Vector,REye_Vector)), dot(Nose_Vector,REye_Vector));
    A_LEye = atan2d(norm(cross(Nose_Vector,LEye_Vector)), dot(Nose_Vector,LEye_Vector));
    
    A_REar = atan2(norm(cross(REye_Vector,REar_Vector)), dot(REye_Vector,REar_Vector));
    A_LEar = atan2(norm(cross(LEye_Vector,LEar_Vector)), dot(LEye_Vector,LEar_Vector));

    
     %% find COM of each segment  -  from original code slight adaptation
     % Thigh o.433 of thigh length
     com_Lthigh = [0.433*(ff(i,25)+ff(i,28)); 0.433*(ff(i,26)+ff(i,29));  0.433*(ff(i,27)+ff(i,30))]; % R thigh
     com_Rthigh = [0.433*(ff(i,34)+ff(i,37)); 0.433*(ff(i,35)+ff(i,38));  0.433*(ff(i,36)+ff(i,39))]; % L thigh
     % Shrank 0.433 of length
     com_Lshrank = [0.433*(ff(i,31)+ff(i,28)); 0.433*(ff(i,32)+ff(i,29));  0.433*(ff(i,33)+ff(i,30))]; % R shrank
     com_Rshrank = [0.433*(ff(i,40)+ff(i,37)); 0.433*(ff(i,41)+ff(i,38));  0.433*(ff(i,42)+ff(i,39))]; % L shrank
     
     com_x_RL = [com_Rthigh(1,1), com_Rshrank(1,1), 0]; % x centre variance - right leg
     com_x_LL = [com_Lthigh(1,1), com_Lshrank(1,1), 0]; % x centre variance - left leg
     com_y_RL = [com_Lthigh(2,1), com_Lshrank(2,1), 0]; % y centre variance - right leg
     com_y_LL= [com_Lthigh(2,1), com_Lshrank(2,1), 0];  % y centre variance - left leg  

     
    %% Send joint angles to coppeliasim - pause the communication so that all angles are changed simultaneously
    sim.simxPauseCommunication(clientID,1);
    
    sim.simxSetJointTargetPosition(clientID, neck_handle, A_Neck(i), sim.simx_opmode_streaming);
    
    sim.simxSetJointTargetPosition(clientID, Rshoulder_handle, A_RShoulder(i), sim.simx_opmode_streaming);
    sim.simxSetJointTargetPosition(clientID, Lshoulder_handle, A_LShoulder(i), sim.simx_opmode_streaming);

    sim.simxSetJointTargetPosition(clientID, Relbow_handle, A_RElbow(i), sim.simx_opmode_streaming);
    sim.simxSetJointTargetPosition(clientID, Lelbow_handle, A_LElbow(i), sim.simx_opmode_streaming);

    sim.simxSetJointTargetPosition(clientID, Rhip_handle, A_RHip(i), sim.simx_opmode_streaming);
    sim.simxSetJointTargetPosition(clientID, Lhip_handle, A_LHip(i), sim.simx_opmode_streaming);
    
    sim.simxSetJointTargetPosition(clientID, Rknee_handle, A_Rknee(i), sim.simx_opmode_streaming);
    sim.simxSetJointTargetPosition(clientID, Lknee_handle, A_Lknee(i), sim.simx_opmode_streaming);

    sim.simxSetJointTargetPosition(clientID, Rankle_handle, A_RFoot(i), sim.simx_opmode_streaming);
    sim.simxSetJointTargetPosition(clientID, Lankle_handle, A_LFoot(i), sim.simx_opmode_streaming);
    
    sim.simxPauseCommunication(clientID,0);
    
end
