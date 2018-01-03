clear;

syms k1 k2 k0 rho(t) % rho is forest dislocation density and e=plastic strain
% eqn1 = diff(rho) == M*(k1*rho^0.5 + k2*rho);

dsolve(diff(rho) == k1*(rho^0.5) + k2*rho +k0,'IgnoreAnalyticConstraints', false);
% % Initial conditions
% c1 = f(0) == 0;
% c2 = g(0) == 1;

% S = dsolve(eqn1);

% ezplot(fSol) %,'Color','r')
% colormap([0 0 1]);
% hold on
% h=ezplot(gSol); %,'Color','b')
% 
% set(h, 'Color', 'r');	
% grid on
% legend('fSol','gSol','Location','best')