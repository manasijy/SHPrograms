 function dx = TIV_ODE(t,x)


%strain = e;

%initialize parameters

Ls = 1e-8;
k1 = 8.79;
kL = 1;
k2 = 1.21;
G = 5e10;
M = 3;
rhof0 = 1;
alpha = 1/3;
sigma_i = 56e6;
b = 1e-9;

% Ls = 1e-7; %m
% M = 3.01;
% b = 2.86e-10; % m
% k1 = 1.5;
% k2= 2;
% kL = 1;
% alpha = 1/3;
% G = 26e3; %MPa
% sigma_i = 93.86; %MPa
% rhof0 = 1e11;   %m-2



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

