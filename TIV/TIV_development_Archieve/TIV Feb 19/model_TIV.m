clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.
path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
                % filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
filename = strcat(path,'\SH Programs\TIV\TIV Feb18\equispaced.txt');
%filename = 'C:\Users\Intel\Documents\MATLAB\TIV Feb17\modelfit.txt';
delimiter = '\t';

%% Format string for each line of text:
formatSpec = '%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);


%% Create output variable
data1 = dataset(dataArray{1:end-1}, 'VarNames', {'trueStrain','trueStress'});
data = iddata(data1.trueStress(1:100), [], 0.0022,'Name', 'true stress'); % Ts = 0.0022 
%data = iddata(data1.trueStress(1:100),data1.trueStrain(1:100)); % [o/p, i/p]
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;



set(data, 'OutputName', 'Stress');
set(data, 'OutputUnit', 'MPa');
set(data, 'Tstart', 0.0024, 'TimeUnit', 's');







%% PART - II MODEL



Ls = 1e-7; %m
M = 3.01;
b = 2.86e-10; % m
k1 = 1.5;
k2= 2;
kL = 1;
alpha = 1/3;
G = 26e3; %MPa
sigma_i = 93.86; %MPa
rhof0 = 1e11;   %m-2


order         = [1 0 3];  % Order — Vector with three
                            % entries [Ny Nu Nx], specifying the number of model
                            % outputs Ny, the number of inputs Nu, and the number of states Nx. 

param = [Ls,M,b,k1,k2,kL,alpha,G,sigma_i,rhof0]; % [Ls,M,b,k1,k2,kL,alpha,G,sigma_i,rhof0];                           
parameters    = {param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9), param(10)}; %, param(10)

initial_L = 2e-5; %m
initial_rhof = 1e11;%1e11; 
% % intitial_rhom = 1e8;%1e12;
initial_sigma = 93.86;
initial_states = [initial_L; initial_rhof; initial_sigma]; %intitial_rhom;initial_sigma]; 

%Ts            = 0.0022;         
% starting time % This was causing descrete model input and not allowing ods45 to work     


TIVmodel = idnlgrey('TIV', order, parameters, initial_states,0.0022);

% The 'c' input argument in the call to idgrey specifies linear_model as a continuous-time system.
%TIVmodel = idnlgrey('TIV', order, parameters, initial_states, Ts);
         
              
% Out of 10 parameters 5 are constants and need not be updated
%setpar(TIVmodel, 'Fixed', {false true true false false false true true false true});
setpar(TIVmodel, 'Fixed', {false true true false false false true true false true});
 

%setinit(nonlinear_model,'Fixed',{false false true true}) specifies that the initial states of init_sys are free estimation parameters.   

%% To fix algorithm options. If we dont fix then it uses auto mode to select the algorithm options

%  set(TIVmodel,'TimeUnit','s');
%  set(TIVmodel,'CovarianceMatrix','Estimate');
%  TIVmodel.Algorithm.SearchMethod = 'lm';
% lm.StartValue = 0.001;
% lm.LMStep = 10;
% lm.MaxBisections = 25;
% lm.RelImprovement = 1e-9;
% lm.MaxIter= 100;
%                
% TIVmodel.Algorithm.SimulationOptions.Solver = 'ode45';
% TIVmodel.Algorithm.GradientOptions.DiffScheme = 'Central approximation';
 
%% Estimation of the model using pem function

setinit(TIVmodel,'Fixed',{true true true}); % true true});
TIVmodel = pem(data,TIVmodel,'Display','Full'); 

b_est = TIVmodel.Parameters(4).Value;
[nonlinear_b_est, sdnonlinear_b_est] = ...
                            getpvec(TIVmodel, 'free'); 
                        

                        
%% Plotting of the results

%compare(data,TIVmodel)


%% Some commands which can be given at the prompt to extract more results

%  sim(TIVmodel,data)
% findstates(TIVmodel,data,initial_states)
% sys = n4sid(data,4) 


                        
                        
