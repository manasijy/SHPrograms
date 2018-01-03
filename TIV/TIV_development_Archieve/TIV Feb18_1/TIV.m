
function [dy, sigma]= TIV(t,x,k1,kL,Ls,M,b,k2,alpha,sigma_i,rhof0,G,varargin)



%strain = e;
L = x(1);   % mean obstacle specing  
rhof = x(2);    % forest
rhom = x(3);    % mobile
sigma = x(4);   % flow stress

% where to fit the strain

dL = -kL*(L-Ls);
drhof = M*((k1/(b*L))- k2*rhof);
drhom = (M/b)*(1/Ls-1/L);
dsigma = (((M*alpha*G*b)^2)/...
        (2*(sigma-(sigma_i-M*alpha*G*b*rhof0^(0.5)))))*...
        drhof;

dy = [dL;drhof;drhom;dsigma];
sigma = sigma_i + M*alpha*G*b*sqrt(rhof);
end


















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