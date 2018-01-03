
function [dy, sigma]= TIVEst(t,x,~,k1,k2,k3,k4,M,b,alpha,sigma_i,G,varargin)


rho_m = x(1);    
rho_f = x(2);   



drho_m = M*(-k1*sqrt(rho_f)-k3*rho_m+k4*rho_f/rho_m);   %-kL*(L-Ls);
drho_f = M*(k1*sqrt(rho_f))-k2*rho_f+k3*rho_m;   %M*((k1/(b*L))- k2*rhof);

dy =  [drho_m;drho_f];
sigma = sigma_i + M*alpha*G*b*sqrt(rho_f);
end
