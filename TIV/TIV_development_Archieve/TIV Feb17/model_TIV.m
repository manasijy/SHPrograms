clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.
path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
                % filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
filename = strcat(path,'\SH Programs\TIV\TIV Feb17\modelfit.txt');
% filename = 'C:\Users\Intel\Documents\MATLAB\TIV Feb17\modelfit.txt';
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
data = iddata(data1.trueStress(1:100),data1.trueStrain(1:100)); % [o/p, i/p]
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;









%% PART - II MODEL



Ls = 1e-7; %m
M = 3.01;
b = 2.86e-10; % m
k1 = 1.5;
k2= 2;
kL = 1;
alpha = 1/3;
G = 26e3; %MPa
sigma_i = 50; %Pa
rhof0 = 1e11;   %m-2


order         = [1 1 4];  % Order — Vector with three
                            % entries [Ny Nu Nx], specifying the number of model
                            % outputs Ny, the number of inputs Nu, and the number of states Nx. 

param = [Ls,M,b,k1,k2,kL,alpha,G,sigma_i,rhof0];                            
parameters    = {param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9), param(10)};

initial_L = 1e-6; %m
initial_rhof = 1e10; 
intitial_rhom = 1e11;
initial_sigma = 93.86;
initial_states = [initial_L; initial_rhof; intitial_rhom;initial_sigma];  % initialize state variables
%[10e-6; 1e10; 1e11;50e6];  % initialize state variables
%es            = 1;         
% starting time % This was causing descrete input model and not allowing ods45 to work     


TIVmodel = idnlgrey('TIV', order, parameters, initial_states);
%TIVmodel = idnlgrey('TIV', order, parameters, initial_states, es);
         
              
% Out of 10 parameters 5 are constants and need not be updated
%setpar(TIVmodel, 'Fixed', {false true true false false false true true false true});
setpar(TIVmodel, 'Fixed', {false true true false false false true true true true});
 

%setinit(nonlinear_model,'Fixed',{false false true true}) specifies that the initial states of init_sys are free estimation parameters.   

set(TIVmodel,'TimeUnit','s');
set(TIVmodel,'CovarianceMatrix','Estimate');
TIVmodel.Algorithm.SearchMethod = 'lm';
TIVmodel.Algorithm.MaxIter = 100;
TIVmodel.Algorithm.SimulationOptions.RelTol = 1e-6;
TIVmodel.Algorithm.SimulationOptions.Solver = 'ode45';

setinit(TIVmodel,'Fixed',{true true true true});

TIVmodel = pem(data,TIVmodel,'Display','Full'); 

b_est = TIVmodel.Parameters(4).Value;
[nonlinear_b_est, sdnonlinear_b_est] = ...
                            getpvec(TIVmodel, 'free'); 
                      
compare(data,TIVmodel);
%  TIVmodel_1.CovarianceMatrix;
%  TIVmodel_1.EstimationInfo;
                        
                        
