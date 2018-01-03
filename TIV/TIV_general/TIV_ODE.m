 function dx = TIV_ODE(t,x)


%strain = e;

%initialize parameters

% Ls = 1e-8;
% k1 = 8.79;
% kL = 1;
% k2 = 1.21;
% G = 5e10;
% M = 3;
% rhof0 = 1;
% alpha = 1/3;
% sigma_i = 56e6;
% b = 1e-9;

% Ls = 4.5e-8; %m 1e-6
% M = 3.01; % 2.96
% b = 2.86e-10; % m
% k1 = 0.015346;
% k2= -0.332; %5-10
% kL = 0.8099; % 100-400
% alpha = 1/3;
% G = 26e9; %Pa
% sigma_i = 92.35e6; %Pa
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



L = x(1);   % mean obstacle specing  
rhof = x(2);    % forest
rhom = x(3);    % mobile
sigma = x(4);   % flow stress


dL = -kL*(L-Ls);
drhof = M*((k1/(b*L))- k2*rhof);
drhom = (M/b)*(1/Ls-1/L);
dsigma = (((M*alpha*G*b)^2)/...
        (2*(sigma-(sigma_i-M*alpha*G*b*rhof0^(0.5)))))*...
        drhof;

dx = [dL;drhof;drhom;dsigma];
end

