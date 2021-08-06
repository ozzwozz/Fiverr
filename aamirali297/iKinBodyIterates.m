% % 
% W1 = 0.109;
% W2 = 0.082;
% L1 = 0.425;
% L2 = 0.392;
% H1 = 0.089;
% H2 = 0.095;
% 
% Blist = [[0; 1; 0; W1+W2; 0; L1+L2], [0; 0; 1; H2; -L1-L2; 0], [0; 0; 1; H2; -L2; 0], [0;0;1;H2;0;0;], [0;-1;0;-W2;0;0;], [0;0;1;0;0;0;]];
% M = [[-1, 0, 0, L1+L2]; [0, 0, 1, W1+W2]; [0, 1, 0, H1-H2]; [0, 0, 0, 1]];
% T = [[0, 1, 0, -0.5]; [0, 0, -1, 0.1]; [-1, 0, 0, 0.1]; [0, 0, 0, 1]];
% thetalist0 = [2.5; 5; 1.7; -0.5; -0.5; 4];
% eomg = 0.01;
% ev = 0.001;
% % 

function [thetalist, success] = IKinBodyIterates(Blist, M, T, thetalist0, eomg, ev)


thetalist = thetalist0;
i = 0;
maxiterations = 20;
Vb = se3ToVec(MatrixLog6(TransInv(FKinBody(M, Blist, thetalist)) * T));
err = norm(Vb(1: 3)) > eomg || norm(Vb(4: 6)) > ev; %   norm of angles 1-3 greater than  orientation tolerance or angles 4-6 greater than linear tolerance
    
    while err && i < maxiterations %    as long as error is true and max iterations not exceeded
        thetalist = thetalist + pinv(JacobianBody(Blist, thetalist)) * Vb; % calculate joint angles that achieve T
        i = i + 1;  % next iteration
        Vb = se3ToVec(MatrixLog6(TransInv(FKinBody(M, Blist, thetalist)) * T));
        err = norm(Vb(1: 3)) > eomg || norm(Vb(4: 6)) > ev;
        writematrix(rot90(thetalist),'iterates.csv', 'WriteMode','append'); % write angles to iterates.csv for each iteration

    end

success = ~ err;
end

