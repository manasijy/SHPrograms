clear;
close;

%% PART I- DATA IMPORT

%% Descret DATA

% %% Initialize variables.
% 
% % For lab computer
% 
% path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
%                 % filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
% filename = strcat(path,'\SH Programs\TIV\TIV_Estrin\equispaced.txt');
% 
% % for home computer
% % filename = 'C:\Users\Intel\Documents\MATLAB\TIV Feb 19\realTIV\equispaced.txt'; %equispaced modelfit.txt
% 
% %%
% 
% delimiter = '\t';
% formatSpec = '%f%f%[^\n\r]'; 
% 
% %% Open the text file.
% fileID = fopen(filename,'r');
% 
% %% Read columns of data according to format string.
% dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
% 
% %% Close the text file.
% fclose(fileID);
% 
% 
% %% Create output variable
% 
% data1 = dataset(dataArray{1:end-1}, 'VarNames', {'trueStrain','trueStress'});
% data = iddata(data1.trueStress(1:100), [], 0.0022,'Name', 'true stress'); % Ts = 0.0022 
% 
% %data = iddata(data1.trueStress(1:100),data1.trueStrain(1:100)); % [o/p, i/p]
% 
% %% Clear temporary variables
% 
% clearvars filename delimiter formatSpec fileID dataArray ans;
% set(data, 'OutputName', 'Stress');
% set(data, 'OutputUnit', 'MPa');
% set(data, 'Tstart',0.0024, 'TimeUnit', 's');%0.0024

%% Continulous data

% For lab computer

path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
                % filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
filename = strcat(path,'\SH Programs\solutionized.txt');

% for home computer
% filename = 'C:\Users\Intel\Documents\MATLAB\TIV Feb 19\realTIV\equispaced.txt'; %equispaced modelfit.txt

g = fopen(filename,'r');                            

dt = textscan(g, '%f %f');

t = dt{1,1}(:);
y = dt{1,2}(:);
w = polyfit(t,y,6);
Stress = polyval(w,t);
data = iddata(Stress,[],0.001,'Name','true stress');


%% PART - II MODEL


%% Parameter initialization

%k,k1,k2,k3,k4,M,b,alpha,sigma_i,G,varargin

%k = 0.8e-7; %m
M = 2.96;
b = 2.86e-10; % m
k1 = 22e5;
k2= 6.6;
k3 =110;
k4 = 4e11;
alpha = 1/3;
G = 26e3; %MPa
sigma_i =93.86; %MPa
% rho_f0 = 1e11;   %m-2
% rho_m0 = 1e10;
param = [k1,k2,k3,k4,M,b,alpha,sigma_i,G];                      
parameters    = {param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9)}; 

%% Order of the model % Order 
% Vector with three entries [Ny Nu Nx], specifying the number of model
% outputs Ny, the number of inputs Nu, and the number of states Nx

order         = [1 0 2];  
                           
                           
%% State variable initialization


rho_m0 = 2e10;
rho_f0 = 1e11; 

initial_states = [rho_m0; rho_f0];

%% Model definition

%TIVmodel = idnlgrey('TIVEst', order, parameters, initial_states,0.0022);   % for descrete data

TIVmodel = idnlgrey('TIVEst', order, parameters, initial_states);   % for continuous data

TIVmodel.Algorithm.MaxIter = 20;

% Sampling time for descrete time data Ts = 0.0022

%%  Fixiing of parameters             
% Out of 10 parameters 5 are constants and need not be updated

setpar(TIVmodel, 'Fixed', {false false false false true true true true true});

%% Fixing of initial state variables

setinit(TIVmodel,'Fixed',{true true});
%% To fix algorithm options. If we dont fix then it uses auto mode to select the algorithm options

 set(TIVmodel,'TimeUnit','s');
 set(TIVmodel,'CovarianceMatrix','Estimate');
 TIVmodel.Algorithm.SearchMethod = 'auto';%'lm';
lm.StartValue = 0.0;
lm.LMStep = 10;
lm.MaxBisections = 25;
lm.RelImprovement = 1e-9;
lm.MaxIter= 100;
               
TIVmodel.Algorithm.SimulationOptions.Solver = 'ode45';
TIVmodel.Algorithm.GradientOptions.DiffScheme = 'Central approximation';
 

%% Estimation of the model using pem function

TIVmodel = pem(data,TIVmodel,'Display','Full'); 


%% Outputs of the model

% b_est = TIVmodel.Parameters(4).Value;
[nonlinear_b_est, sdnonlinear_b_est] = ...
                            getpvec(TIVmodel, 'free');

fprintf(' estimated value of k is %f +- %f \n', nonlinear_b_est(1), sdnonlinear_b_est(1));
fprintf(' estimated value of k1 is %f +- %f \n', nonlinear_b_est(2), sdnonlinear_b_est(2));
fprintf(' estimated value of k2 is %f +- %f \n', nonlinear_b_est(3), sdnonlinear_b_est(3));
fprintf(' estimated value of k3 is %f +- %f \n', nonlinear_b_est(4), sdnonlinear_b_est(4));


                        
%% Plotting of the results

compare(data,TIVmodel)


%% Some commands which can be given at the prompt to extract more results

%  sim(TIVmodel,data)
% findstates(TIVmodel,data,initial_states)
% sys = n4sid(data,4) 


                        
                        
