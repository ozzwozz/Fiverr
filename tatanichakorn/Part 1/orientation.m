clear all; clc;
disp('Program started');
% ff = load('C:\trs\ws_emor\emor_trs-master\y-asti\csvF\s1a_16_transformed.csv');
ff = load('s1a_16_2.csv');
time = load('s1a_16.csv');

% FORMULA  angle = arccos[(xa * xb + ya * yb + za * zb) / (?(xa2 + ya2 + za2) * ?(xb2 + yb2 + zb2))]

sim=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
sim.simxFinish(-1); % just in case, close all opened connections
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);

% Now send some data to CoppeliaSim in a non-blocking fashion:
sim.simxAddStatusbarMessage(clientID,'Hello CoppeliaSim!', sim.simx_opmode_oneshot);

[returnCode, neck_handle] = sim.simxGetObjectHandle(clientID,'neckJoint1', sim.simx_opmode_blocking);
disp(returnCode);

[returnCode, Lshoulder_handle] = sim.simxGetObjectHandle(clientID,'leftArmJoint0', sim.simx_opmode_blocking);
disp(returnCode);
[returnCode,Lelbow_handle] = sim.simxGetObjectHandle(clientID,'leftArmJoint2', sim.simx_opmode_blocking);
disp(returnCode);

[returnCode,Rshoulder_handle] = sim.simxGetObjectHandle(clientID,'rightArmJoint0', sim.simx_opmode_blocking);
disp(returnCode);
[returnCode,Relbow_handle] = sim.simxGetObjectHandle(clientID,'rightArmJoint2', sim.simx_opmode_blocking);
disp(returnCode);

[returnCode,Lhip_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint2', sim.simx_opmode_blocking);
disp(returnCode);
[returnCode,Lknee_handle] = sim.simxGetObjectHandle(clientID,'leftLegJoint3', sim.simx_opmode_blocking);
disp(returnCode);

[returnCode,Rhip_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint2', sim.simx_opmode_blocking);
disp(returnCode);
[returnCode,Rknee_handle] = sim.simxGetObjectHandle(clientID,'rightLegJoint3', sim.simx_opmode_blocking);
disp(returnCode);

figure(1); hold on;
% axis([-1 1 -1 1]);
JointAngles = [];
for i=1:50
    cla;
    % vector from joint-joint
    nose_neck(i) = sqrt( (ff(i,1)-ff(i,4))^2 + (ff(i,2)-ff(i,5))^2 + (ff(i,3)-ff(i,6))^2 );
        % RIGHT ARM
    Rshoulder_neck(i) = sqrt( (ff(i,7)-ff(i,4))^2 + (ff(i,8)-ff(i,5))^2 + (ff(i,9)-ff(i,6))^2 );
    Rshoulder_Relbow(i) = sqrt( (ff(i,7)-ff(i,10))^2 + (ff(i,8)-ff(i,11))^2 + (ff(i,9)-ff(i,12))^2 );                                 
    Relbow_Rwrist(i) = sqrt( (ff(i,10)-ff(i,13))^2 + (ff(i,11)-ff(i,14))^2 + (ff(i,12)-ff(i,15))^2 );
    
        % LEFT ARM
    neck_Lshoulder(i) =  sqrt( (ff(i,4)-ff(i,16))^2 + (ff(i,5)-ff(i,17))^2 + (ff(i,6)-ff(i,18))^2 );
    Lshoulder_Lelbow(i) = sqrt( (ff(i,16)-ff(i,19))^2 + (ff(i,17)-ff(i,20))^2 + (ff(i,18)-ff(i,21))^2 );
    Lelbow_Lwrist(i) = sqrt( (ff(i,19)-ff(i,22))^2 + (ff(i,20)-ff(i,23))^2 + (ff(i,21)-ff(i,24))^2 );
    
        % Body
    neck_Rhip(i) = sqrt( (ff(i,4)-ff(i,25))^2 + (ff(i,5)-ff(i,26))^2 + (ff(i,6)-ff(i,27))^2 );
    neck_Lhip(i) = sqrt( (ff(i,4)-ff(i,34))^2 + (ff(i,5)-ff(i,35))^2 + (ff(i,6)-ff(i,36))^2 );
    
        % RIGHT LEG
    Rhip_Rknee(i) = sqrt( (ff(i,25)-ff(i,28))^2 + (ff(i,26)-ff(i,29))^2 + (ff(i,27)-ff(i,30))^2 );
    Rknee_Rfoot(i) = sqrt( (ff(i,28)-ff(i,31))^2 + (ff(i,29)-ff(i,32))^2 + (ff(i,30)-ff(i,33))^2 );
        
        % LEFT LEG
    Lhip_Lknee(i) = sqrt( (ff(i,34)-ff(i,37))^2 + (ff(i,35)-ff(i,38))^2 + (ff(i,36)-ff(i,39))^2 );    
    Lknee_Lfoot(i) = sqrt( (ff(i,37)-ff(i,40))^2 + (ff(i,38)-ff(i,41))^2 + (ff(i,39)-ff(i,42))^2 );
    
    % angles joints
    v_neck(1:3,i) = [ ff(i,4)-ff(i,1); ff(i,2)-ff(i,5);  ff(i,3)-ff(i,6) ] ;
    v_Rshoulder(1:3,i) = [ ff(i,4)-ff(i,7); ff(i,5)-ff(i,8); ff(i,6)-ff(i,9) ];
    v_upperRArm(1:3,i) = [ ff(i,10)-ff(i,7); ff(i,11)-ff(i,8); ff(i,12)-ff(i,9) ];
    v_foreRArm(1:3,i) = [ ff(i,13)-ff(i,10); ff(i,14)-ff(i,11); ff(i,15)-ff(i,12) ];
    v_Lshoulder(1:3,i) = [ ff(i,4)-ff(i,16); ff(i,5)-ff(i,17); ff(i,6)-ff(i,18) ];
    v_upperLArm(1:3,i) = [ ff(i,19)-ff(i,16); ff(i,20)-ff(i,17); ff(i,21)-ff(i,18) ];
    v_foreLArm(1:3,i) = [ ff(i,22)-ff(i,19); ff(i,23)-ff(i,20); ff(i,24)-ff(i,21) ];
    v_Lbody(1:3,i) = [ ff(i,4)-ff(i,25); ff(i,5)-ff(i,26); ff(i,6)-ff(i,27) ];
    v_Rbody(1:3,i) = [ ff(i,4)-ff(i,34); ff(i,5)-ff(i,35); ff(i,6)-ff(i,36) ];
    v_Rtigh(1:3,i) = [ ff(i,28)-ff(i,25); ff(i,29)-ff(i,26); ff(i,30)-ff(i,27) ];
    v_Ltigh(1:3,i) = [ ff(i,37)-ff(i,34); ff(i,38)-ff(i,35); ff(i,39)-ff(i,36) ]; 
    v_Rleg(1:3,i) = [ ff(i,31)-ff(i,28); ff(i,32)-ff(i,29); ff(i,33)-ff(i,30) ];
    v_Lleg(1:3,i) = [ ff(i,40)-ff(i,37); ff(i,41)-ff(i,38); ff(i,42)-ff(i,39) ];
    
    storage = [v_neck(1:3,i),v_Rshoulder(1:3,i),  v_upperRArm(1:3,i), v_foreRArm(1:3,i), v_Lshoulder(1:3,i), v_upperLArm(1:3,i), v_foreLArm(1:3,i), ...
        v_Lbody(1:3,i), v_Rbody(1:3,i), v_Rtigh(1:3,i),v_Rleg(1:3,i), v_Ltigh(1:3,i),v_Rleg(1:3,i)];
       
    
    
    % angles joints
    A_Rshoulder(i,1) = rad2deg(acos((v_Rshoulder(1,i)*v_upperRArm(1,i) + v_Rshoulder(2,i)*v_upperRArm(2,i) +  v_Rshoulder(3,i)*v_upperRArm(3,i))/ ...
        ( sqrt(v_Rshoulder(1,i)^2 + v_Rshoulder(2,i)^2 + v_Rshoulder(3,i)^2) * sqrt(v_upperRArm(1,i)^2 + v_upperRArm(2,i)^2 + v_upperRArm(3,i)^2))) ); 
    A_Lshoulder(i,1) = rad2deg(acos((v_Lshoulder(1,i)*v_upperLArm(1,i) + v_Lshoulder(2,i)*v_upperLArm(2,i) + v_Lshoulder(3,i)*v_upperLArm(3,i))/ ...
        ( sqrt(v_Lshoulder(1,i)^2 + v_Lshoulder(2,i)^2 + v_Lshoulder(3,i)^2) * sqrt(v_upperLArm(1,i)^2 + v_upperLArm(2,i)^2 + v_upperLArm(3,i)^2))) );     
    A_Relbow(i,1) = rad2deg(acos(( (-v_upperRArm(1,i))*v_foreRArm(1,i) + (-v_upperRArm(2,i))*v_foreRArm(2,i) +  (-v_upperRArm(3,i))*v_foreRArm(3,i) )/ ...
        ( sqrt(v_upperRArm(1,i)^2 + v_upperRArm(2,i)^2 + v_upperRArm(3,i)^2) * sqrt(v_foreRArm(1,i)^2 + v_foreRArm(2,i)^2 + v_foreRArm(3,i)^2))) ); 
    A_Lelbow(i,1) = rad2deg(acos(( (-v_upperLArm(1,i))*v_foreLArm(1,i) + (-v_upperLArm(2,i))*v_foreLArm(2,i) +  (-v_upperLArm(3,i))*v_foreLArm(3,i) )/ ...
        ( sqrt(v_upperLArm(1,i)^2 + v_upperLArm(2,i)^2 + v_upperLArm(3,i)^2) * sqrt(v_foreLArm(1,i)^2 + v_foreLArm(2,i)^2 + v_foreLArm(3,i)^2))) );
    
    A_Rhip(i,1) = rad2deg(acos(( v_Rbody(1,i)*v_Rtigh(1,i) + v_Rbody(2,i)*v_Rtigh(2,i) + v_Rbody(3,i)*v_Rtigh(3,i) )/ ...
        ( sqrt(v_Rbody(1,i)^2 + v_Rbody(2,i)^2 + v_Rbody(3,i)^2) * sqrt(v_Rtigh(1,i)^2 + v_Rtigh(2,i)^2 + v_Rtigh(3,i)^2)))) ; 
    A_Lhip(i,1) = rad2deg(acos(( v_Lbody(1,i)*v_Ltigh(1,i) + v_Lbody(2,i)*v_Ltigh(2,i) + v_Lbody(3,i)*v_Ltigh(3,i) )/ ...
        ( sqrt(v_Lbody(1,i)^2 + v_Lbody(2,i)^2 + v_Lbody(3,i)^2) * sqrt(v_Ltigh(1,i)^2 + v_Ltigh(2,i)^2 + v_Ltigh(3,i)^2)))) ; 
    A_Lknee(i,1) = rad2deg(acos(( (-v_Ltigh(1,i))*v_Lleg(1,i) - v_Ltigh(2,i)*v_Lleg(2,i) - v_Ltigh(3,i)*v_Lleg(3,i) )/ ...
        ( sqrt(v_Ltigh(1,i)^2 + v_Ltigh(2,i)^2 + v_Ltigh(3,i)^2) * sqrt(v_Lleg(1,i)^2 + v_Lleg(2,i)^2 + v_Lleg(3,i)^2)))) ;
    A_Rknee(i,1) = rad2deg(acos(( (-v_Rtigh(1,i))*v_Rleg(1,i) - v_Rtigh(2,i)*v_Rleg(2,i) - v_Rtigh(3,i)*v_Rleg(3,i) )/ ...
        ( sqrt(v_Rtigh(1,i)^2 + v_Rtigh(2,i)^2 + v_Rtigh(3,i)^2) * sqrt(v_Rleg(1,i)^2 + v_Rleg(2,i)^2 + v_Rleg(3,i)^2)))) ;
    
    JointAngles = [JointAngles; A_Rshoulder(i,1),A_Lshoulder(i,1), A_Relbow(i,1),A_Lelbow(i,1), A_Rhip(i,1), A_Lhip(i,1), A_Lknee(i,1), A_Rknee(i,1)];

    
    
    %sim.simxSetJointTargetPosition(clientID, neck_handle, JointAngles(i,1), sim.simx_opmode_oneshot);
    
    sim.simxSetJointTargetPosition(clientID, Rshoulder_handle, JointAngles(i,1), sim.simx_opmode_oneshot);
    sim.simxSetJointTargetPosition(clientID, Relbow_handle, JointAngles(i,2), sim.simx_opmode_oneshot);
    
    sim.simxSetJointTargetPosition(clientID, Lshoulder_handle, JointAngles(i,3), sim.simx_opmode_oneshot);
    sim.simxSetJointTargetPosition(clientID, Lelbow_handle, JointAngles(i,4), sim.simx_opmode_oneshot);

    sim.simxSetJointTargetPosition(clientID,Rhip_handle, JointAngles(i,5), sim.simx_opmode_oneshot);
    sim.simxSetJointTargetPosition(clientID, Rknee_handle, JointAngles(i,6), sim.simx_opmode_oneshot);

    sim.simxSetJointTargetPosition(clientID, Lhip_handle, JointAngles(i,7), sim.simx_opmode_oneshot);
    sim.simxSetJointTargetPosition(clientID, Lknee_handle, JointAngles(i,8), sim.simx_opmode_oneshot);
    % transform
    
    
    
    
    % plot
    
    % right side UP
    line( [ff(i,7) ff(i,4)], [ ff(i,8) ff(i,5) ],  [ ff(i,9) ff(i,6) ], 'linewidth', 3, 'color', 'r'); % R shoulder
    line( [ff(i,10) ff(i,7)], [ ff(i,11) ff(i,8) ],  [ ff(i,12) ff(i,9) ], 'linewidth', 3, 'color', 'r'); % R UpperArm
    line( [ff(i,13) ff(i,10)], [ ff(i,14) ff(i,11) ],  [ ff(i,15) ff(i,12) ], 'linewidth', 3, 'color', 'r'); % R ForeArm    
        
    % Left side UP
    line( [ff(i,16) ff(i,4)], [ ff(i,17) ff(i,5) ],  [ ff(i,18) ff(i,6) ], 'linewidth', 3, 'color', 'b'); % L shoulder
    line( [ff(i,19) ff(i,16)], [ ff(i,20) ff(i,8) ],  [ ff(i,21) ff(i,18) ], 'linewidth', 3, 'color', 'b'); % R UpperArm
    line( [ff(i,22) ff(i,19)], [ ff(i,23) ff(i,20) ],  [ ff(i,24) ff(i,21) ], 'linewidth', 3, 'color', 'b'); % R ForeArm      
    
    % body
    line( [ff(i,1) ff(i,4)], [ ff(i,2) ff(i,5) ],  [ ff(i,3) ff(i,6) ], 'linewidth', 3, 'color', 'g'); % neck
%     line( [ff(i,25) ff(i,4)], [ ff(i,26) ff(i,5) ],  [ ff(i,27) ff(i,6) ], 'linewidth', 3, 'color', 'g'); % right
%     line( [ff(i,34) ff(i,4)], [ ff(i,35) ff(i,5) ],  [ ff(i,36) ff(i,6) ], 'linewidth', 3, 'color', 'g'); % left
    line( [ff(i,25) ff(i,7)], [ ff(i,26) ff(i,8) ],  [ ff(i,27) ff(i,9) ], 'linewidth', 3, 'color', 'g'); % R shoulder-hip
    line( [ff(i,34) ff(i,16)], [ ff(i,35) ff(i,17) ],  [ ff(i,36) ff(i,18) ], 'linewidth', 3, 'color', 'g'); % L shoulder-hip
    line( [ff(i,34) ff(i,25)], [ ff(i,35) ff(i,26) ],  [ ff(i,36) ff(i,27) ], 'linewidth', 3, 'color', 'g'); % LR hip
    
    % right side BUTTOM
    line( [ff(i,25) ff(i,28)], [ ff(i,26) ff(i,29) ],  [ ff(i,27) ff(i,30) ], 'linewidth', 3, 'color', 'r'); % R tigh
    line( [ff(i,31) ff(i,28)], [ ff(i,32) ff(i,29) ],  [ ff(i,33) ff(i,30) ], 'linewidth', 3, 'color', 'r'); % R shrank  
        
    % Left side BUTTOM
    line( [ff(i,34) ff(i,37)], [ ff(i,35) ff(i,38) ],  [ ff(i,36) ff(i,39) ], 'linewidth', 3, 'color', 'b'); % L tigh
    line( [ff(i,40) ff(i,37)], [ ff(i,41) ff(i,38) ],  [ ff(i,42) ff(i,39) ], 'linewidth', 3, 'color', 'b'); % L shrank 
    
%     line(v_upperRArm(1:3,i), v_foreRRArm(1:3,i), 'linewidth', 3, 'color', 'k'); % upper arm

%     left side
    
     
     %% find COM of each segment
     % Thigh o.433 of thigh length
     com_Lthigh = [0.433*(ff(i,25)+ff(i,28)); 0.433*(ff(i,26)+ff(i,29));  0.433*(ff(i,27)+ff(i,30))]; % R thigh
     com_Rthigh = [0.433*(ff(i,34)+ff(i,37)); 0.433*(ff(i,35)+ff(i,38));  0.433*(ff(i,36)+ff(i,39))]; % L thigh
     % Shrank 0.433 of length
     com_Lshrank = [0.433*(ff(i,31)+ff(i,28)); 0.433*(ff(i,32)+ff(i,29));  0.433*(ff(i,33)+ff(i,30))]; % R shrank
     com_Rshrank = [0.433*(ff(i,40)+ff(i,37)); 0.433*(ff(i,41)+ff(i,38));  0.433*(ff(i,42)+ff(i,39))]; % L shrank
     
     com_x(i,:) = [com_Rthigh(1,1), com_Rshrank(1,1), com_Lthigh(1,1), com_Lshrank(1,1)];
     com_y(i,:) = [com_Rthigh(2,1), com_Rshrank(2,1), com_Lthigh(2,1), com_Lshrank(2,1)];
     pause(0.1);  
     
     
     %% velocity
     dx_lib = []; % library to store Vx
     dy_lib = []; % library to store Vx
     if i >=3
         k = i-1;         
         dx_temp = [];
         dy_temp = [];
            for j = 1:4
                dx = (com_x(k+1, j)-com_x(k-1,j))./((time(k+1,1)- time(k-1,1)));
                dy = (com_y(k+1, j)-com_y(k-1,j))./((time(k+1,1)- time(k-1,1)));
                dx_temp = [dx_temp, dx];
                dy_temp = [dy_temp, dy];
            end
            dx_lib = [dx_lib; dx_temp];
            dy_lib= [dy_lib; dy_temp];
         
         
         
         
         
     end
     
     
     
     
 
end
hold off;




    %% function 
function [new_location]= local2global(translation,JointAngles,local_coordinate)

    R = [cos(JointAngles) -sin(JointAngles);
    sin(JointAngles) cos(JointAngles)];

    new_location=translation+R*local_coordinate;

end