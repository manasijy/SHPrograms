% Search "Creating IDNLGREY Model Files" for help on this type of models
% IDNLGREY supports estimation of parameters and initial states in nonlinear model structures 



clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.
filename = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\Strain Hardening2\modelfit.txt';
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
data = iddata(data1.trueStress,data1.trueStrain);
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;









%% PART - II MODEL



Fs = 4e9;%Ls
M = 3.01;
%b = 0.286e-9; % m
k1 = 8.5;
k2= 1.2;
%kL = 0.1;
alpha = 1/3;
G = 1e11; %Pa
sigma_i = 0; %Pa
rhof0 = 1e10;   %m-2


order         = [1 1 4];  % Order — Vector with three
                            % entries [Ny Nu Nx], specifying the number of model
                            % outputs Ny, the number of inputs Nu,
                            % and the number of states Nx. 
                            
parameters    = {Fs,M,k1,k2,alpha,G,sigma_i,rhof0}; % 10 parameters

% t,x,e, k1,Fs,M,k2,alpha,sigma_i,rhof0,G,varargin
%initial_states = [10e-6; 1e10; 1e11;50e6];  % initialize state variables
initial_states = [1e9; 1e10; 1e11;10];  % initialize state variables

es            = 1;         % starting strain          
nonlinear_model = idnlgrey('TIV', order, ...
                  parameters, initial_states, es);
%setpar(nonlinear_model, 'Fixed', {false true true false false false true true false true});
setpar(nonlinear_model, 'Fixed', {false true false false true true true true});

nonlinear_model = pem(data,nonlinear_model);
% nonlinear_model = pem(data,nonlinear_model,'Display','Full'); %The pem command updates the parameter of nonlinear_model.
b_est = nonlinear_model.Parameters(4).Value;
[nonlinear_b_est, dnonlinear_b_est] = ...
                            getpvec(nonlinear_model, 'free'); 
                        
                        
                        
%  Using pem to Estimate Nonlinear Grey-Box ModelsYou can use the pem command
% to estimate the unknown idnlgrey model parameters
% and initial states using measured data.The input-output dimensions of the data must be compatible with
% the input and output orders you specified for the idnlgrey model.

% Use the following general estimation syntax:m = pem(data,m)where data is the estimation data and m is
% the idnlgrey model object you constructed.You can pass additional property-value pairs to pem to
% specify the properties of the model or the estimation algorithm. Assignable
% properties include the ones returned by the get(idnlgrey) command
% and the algorithm properties returned by the get(idnlgrey,
% 'Algorithm'), such as MaxIter and Tolerance.
% For detailed information about these model properties, see the idnlgrey reference page.For more information about validating your models, see Model Validation.
%                         
                        
                        
% getpvec returns, as dnonlinear_b_est,
% the 1 standard deviation uncertainty associated with b,
% the free estimation parameter of nonlinear_model.The estimated value of b, the viscous friction
% coefficient, using nonlinear grey-box estimation is 0.1 with a standard
% deviation of 0.0149.Compare the response of the linear and nonlinear grey-box
% models to the measured data.compare(data,linear_model,nonlinear_model)

% For linear dynamics, represent the model using a linear
% grey-box model (idgrey). Estimate the model coefficients
% using the command greyest.For nonlinear dynamics, represent the model using
% a nonlinear grey-box model (idnlgrey). Estimate
% the model coefficients using the command pe