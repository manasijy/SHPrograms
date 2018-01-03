clear;
close;

%% PART I- DATA IMPORT


%% Initialize variables.
path = 'C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1';
% filename = 'path''C:\Documents and Settings\nilesh\My Documents\MATLAB\MKY1\modelfit.txt';
filename = strcat(path,'\SH Programs\TIV\TIV Feb16\modelfit.txt');
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
data = iddata(data1.trueStress(1:100),data1.trueStrain(1:100));
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

es            = 1;         % starting strain     

% The model is defined. It is a nonlinear greybox model based on the function 'TIV' 
nonlinear_model = idnlgrey('TIV', order, ...
                  parameters, initial_states, es);
              
% Out of 10 parameters 5 are constants and need not be updated
setpar(nonlinear_model, 'Fixed', {false true true false false false true true false true});
%setinit(nonlinear_model,'Fixed',{false false true true}) specifies that the initial states of init_sys are free estimation parameters.   

nonlinear_model = pem(data,nonlinear_model,'Display','Full'); 
%The pem command updates the parameter of nonlinear_model.
%The prediction-error minimization algorithm (pem) is used to update the free parameters of model.

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
% Parameters can be updated like this also
% init_sys.Kp = 10;
% init_sys.Tw = 0.4;
% init_sys.Zeta = 0.5;
% init_sys.Td = 0.1;
% init_sys.Tz = 0.01;                   

