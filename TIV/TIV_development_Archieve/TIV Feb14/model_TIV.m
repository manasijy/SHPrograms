clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.
filename = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
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
modelfit = dataset(dataArray{1:end-1}, 'VarNames', {'trueStrain','trueStress'});
data = modelfit ;
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;









%% PART - II MODEL



Ls = 1e-6;
M = 3.01;
b = 0.286e-9; % nm
k1 = 1;
k2= 0.2;
kL = 0.1;
alpha = 1;
G = 1e11; %Pa
sigma_i = 50e6; %Pa
rhof0 = 1e10;   %m-2


order         = [1 1 4];  % Order — Vector with three
                            % entries [Ny Nu Nx], specifying the number of model
                            % outputs Ny, the number of inputs Nu,
                            % and the number of states Nx. 
                            
parameters    = {Ls,M,b,k1,k2,kL,alpha,G,sigma_i,rhof0};           
initial_states = [10e-6; 1e10; 1e11;50e6];  % initialize state variables

es            = 0.001;         % starting strain          
nonlinear_model = idnlgrey('TIV', order, ...
                  parameters, initial_states, es);
setpar(nonlinear_model, 'Fixed', {false true true false false false true true false true});
              
nonlinear_model = pem(data,nonlinear_model,'Display','Full'); %The pem command updates the parameter of nonlinear_model.
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