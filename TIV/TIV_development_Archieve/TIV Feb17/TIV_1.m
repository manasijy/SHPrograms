function [dy, sigma]= TIV(t,e,x,k1,kL,Ls,M,b,k2,alpha,sigma_i,rhof0,G,varargin)

%function [dy, strain]= TIV(t,x,e,kL,Ls,M,b,k2,alpha,G,varargin)
% here e is the input variable
% if we can give e array as t then it may work.

% x is a state vector. L,rhof, rhom, and sigma are the state variables
% dy is the differential of the state variables
% there are no outputs from the system
% time can be replaced by the strain vector because all the derivatives are
% with respect to strain 

b = 2.86e-10;
F = x(1);   % mean obstacle specing  
rhof = x(2);    % forest
rhom = x(3);    % mobile
sigma = x(4);   % flow stress

%de
%dL = -kL*(L-Ls);
dF = -k1*(F-Fs);
%drhof = M*((k1/(b*L))- k2*rhof);
drhof = M*(F- k2*rhof);
%drhom = (M/b)*(1/Ls-1/L);
drhom = Fs-F;
dsigma = (((M*alpha*G*b)^2)/...
        (2*(sigma-(sigma_i-M*alpha*G*b*rhof0^(0.5)))))*...
        drhof;

dy = [dF;drhof;drhom;dsigma];

sigma = sigma_i + alpha*G*b*sqrt(rhof);
end












% type twotanks_m.m
% function [dx, y] = twotanks_m(t, x, u, A1, k, a1, g, A2, a2, varargin)
% %TWOTANKS_M  A two tank system.
% 
% %   Copyright 2005-2006 The MathWorks, Inc.
% %   $Revision: 1.1.8.1 $ $Date: 2006/11/17 13:29:14 $
% 
% % Output equation.
% y = x(2);                                              % Water level, lower tank.
% 
% % State equations.
% dx = [1/A1*(k*u(1)-a1*sqrt(2*g*x(1)));             ... % Water level, upper tank.
%       1/A2*(a1*sqrt(2*g*x(1))-a2*sqrt(2*g*x(2)))   ... % Water level, lower tank.
%      ];





%  The function, NonlinearPendulum, returns
% the state derivatives and output of the nonlinear motion model of
% the  pendulum using the model coefficients m, g, l and b.Save this function as NonlinearPendulum.m.Create a nonlinear grey-box model associated with
% the NonlinearPendulum function.m = 1; 
% g = 9.81; 
% l = 1; 
% b = 0.2;
% order         = [1 0 2];             
% parameters    = {m,g,l,b};           
% initial_states = [1; 0];             
% Ts            = 0;                   
% nonlinear_model = idnlgrey('NonlinearPendulum', order, ...
%                   parameters, initial_states, Ts);
% Specify m, g and l as known parameters.
% setpar(nonlinear_model, 'Fixed', {true true true false});
% As defined in the previous step, m, g,and l are the first three parameters of nonlinear_model.
% Using the setpar command, m, g,
% and l are specified as fixed values and b is
% specified as a free estimation parameter.Estimate the viscous friction coefficient.
%nonlinear_model = pem(data,nonlinear_model,'Display','Full');
% The pem command updates the parameter of nonlinear_model.b_est = nonlinear_model.Parameters(4).Value;
% [nonlinear_b_est, dnonlinear_b_est] = ...
%                             getpvec(nonlinear_model, 'free')