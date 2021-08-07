clear all;
clc;

disp('Program started');
ff = load('s1a_16_2.csv');
time = load('s1a_16.csv');

function [outputArg1,outputArg2] = Angles(inputArg1,inputArg2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

function plotGraph()
    % PLOT Movement on graph
    figure(1);
    hold on;
        
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
    line( [ff(i,25) ff(i,7)], [ ff(i,26) ff(i,8) ],  [ ff(i,27) ff(i,9) ], 'linewidth', 3, 'color', 'g'); % R shoulder-hip
    line( [ff(i,34) ff(i,16)], [ ff(i,35) ff(i,17) ],  [ ff(i,36) ff(i,18) ], 'linewidth', 3, 'color', 'g'); % L shoulder-hip
    line( [ff(i,34) ff(i,25)], [ ff(i,35) ff(i,26) ],  [ ff(i,36) ff(i,27) ], 'linewidth', 3, 'color', 'g'); % LR hip
    
    % right side BUTTOM
    line( [ff(i,25) ff(i,28)], [ ff(i,26) ff(i,29) ],  [ ff(i,27) ff(i,30) ], 'linewidth', 3, 'color', 'r'); % R tigh
    line( [ff(i,31) ff(i,28)], [ ff(i,32) ff(i,29) ],  [ ff(i,33) ff(i,30) ], 'linewidth', 3, 'color', 'r'); % R shrank  
        
    % Left side BUTTOM
    line( [ff(i,34) ff(i,37)], [ ff(i,35) ff(i,38) ],  [ ff(i,36) ff(i,39) ], 'linewidth', 3, 'color', 'b'); % L tigh
    line( [ff(i,40) ff(i,37)], [ ff(i,41) ff(i,38) ],  [ ff(i,42) ff(i,39) ], 'linewidth', 3, 'color', 'b'); % L shrank
    
    hold off;
end

function velocity()
     % velocity calculations
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