
function [dy, sigma]= TIVbarlat(t,x,~,k1,k2,kL,Ls,M,b,alpha,sigma_i,G,varargin)


L = x(1);    
rhof = x(2);   


dL = -kL*(L-Ls);
drhof = M*((k1/(b*L))- k2*rhof);

dy =  [dL;drhof];
sigma = sigma_i + M*alpha*G*b*sqrt(rhof);
end
