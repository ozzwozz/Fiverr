function [outputArg1,outputArg2] = TestFunction()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %client=b0RemoteApi('b0RemoteApi_matlabClient','b0RemoteApi');
    %thing1 = client.CallScriptFunction('@asti', sim.scripttype_childscript, 0,'b0RemoteApiAddOn')
    %clientID=simxStart('127.0.0.0',19997,true,true,5000,5);
    %thing = simxStartSimulation('b0RemoteApiAddOn')
    thing = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5]
    simx
    outputArg1 = 4;
    outputArg2 = 4;
    
end

