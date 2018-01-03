
function [dy, sigma]= TIV(t,x,~,k1,k2,kL,Ls,sigma_i,rhof0,G,M,b,alpha,varargin)
% TIV(t,x,~,k1,kL,Ls,M,b,k2,alpha,sigma_i,rhof0,G,varargin)



%strain = e;
L = x(1);   % mean obstacle specing  
rhof = x(2);    % forest
rhom = x(3);    % mobile
sigma = x(3);   % flow stress


dL = -kL*(L-Ls);
drhof = M*((k1/(b*L))- k2*rhof);
drhom = (M/b)*(1/Ls-1/L);
dsigma = (((M*alpha*G*b)^2)/...
       (2*(sigma-(sigma_i-M*alpha*G*b*rhof0^(0.5)))))*...
        drhof;

dy =  [dL;drhof;drhom;dsigma];
sigma = sigma_i + M*alpha*G*b*sqrt(rhof);
end
