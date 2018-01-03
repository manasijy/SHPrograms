clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.

% For lab computer

path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
                % filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
filename = strcat(path,'\SH Programs\TIV Model\equispaced.txt');

% for home computer
% filename = 'C:\Users\Intel\Documents\MATLAB\TIV Feb 19\equispaced.txt'; %equispaced modelfit.txt

%%

delimiter = '\t';
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
set(data, 'Tstart',0.0024, 'TimeUnit', 's');%0.0024



%% PART - II MODEL


%% Parameter initialization
% 
% Ls = 0.8e-7; %m
% M = 3.01;
% b = 2.86e-10; % m
% k1 = 0.13;
% k2= 0.2;
% kL = 1.1;
% alpha = 1/3;
% G = 26e3; %MPa
% sigma_i =10; % 93.86; %MPa
% rhof0 = 1e11;   %m-2

Ls = 1e-6; %m 
M = 3.01; % 2.96
b = 2.86e-10; % m
k1 = 2e8;
k2= 5-10;
kL = 150; % 100-400
alpha = 1/3;
G = 26e9; %Pa
sigma_i = 92.35e6; %Pa
rhof0 = 1e11;   %m-2



%
param = [k1,k2,kL,Ls,sigma_i,rhof0,G,M,b,alpha]; % [Ls,M,b,k1,k2,kL,alpha,G,sigma_i,rhof0];                           
parameters    = {param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9), param(10)}; 

%% Order of the model % Order 
% Vector with three entries [Ny Nu Nx], specifying the number of model
% outputs Ny, the number of inputs Nu, and the number of states Nx

order         = [1 0 4];  
                           
                           
%% State variable initialization


initial_L = 3e-5;
initial_rhof = 1e11; 
intitial_rhom = 1e11;
initial_sigma = 50;
initial_states = [initial_L; initial_rhof; intitial_rhom; initial_sigma];

%% Model definition

TIVmodel = idnlgrey('TIV', order, parameters, initial_states,0.0022);
TIVmodel.Algorithm.MaxIter = 200;
% Sampling time for descrete time data Ts = 0.0022

%%  Fixiing of parameters             
% Out of 10 parameters 5 are constants and need not be updated

setpar(TIVmodel, 'Fixed', {false false false false false true true true true true });

%% Fixing of initial state variables

setinit(TIVmodel,'Fixed',{true true true true});


%% Estimation of the model using pem function

TIVmodel = pem(data,TIVmodel,'Display','Full'); 


%% Outputs of the model

% [nonlinear_b_est, sdnonlinear_b_est] = ...
%                             getpvec(TIVmodel, 'free')
%                         
% fprintf(' estimated value of k1 is "%f" \n', TIVmodel.Parameters(1).Value);
% fprintf(' estimated value of k2 is "%f" \n', TIVmodel.Parameters(2).Value);
% fprintf(' estimated value of kL is "%f" \n', TIVmodel.Parameters(3).Value);
% fprintf(' estimated value of Ls is "%f" \n', TIVmodel.Parameters(4).Value);
% fprintf(' estimated value of sigma_i is "%f" \n', TIVmodel.Parameters(5).Value);
                        
%% Plotting of the results

compare(data,TIVmodel)


%% Some commands which can be given at the prompt to extract more results

%  sim(TIVmodel,data)
% findstates(TIVmodel,data,initial_states)
% sys = n4sid(data,4) 


                        
                        
