clear;

syms f(t) g(t)
eqn1 = diff(f) == 3*f + 4*g;
eqn2 = diff(g) == -4*f + 3*g;

% Initial conditions
c1 = f(0) == 0;
c2 = g(0) == 1;

S = dsolve(eqn1, eqn2,c1,c2);

fSol(t) = S.f;
gSol(t) = S.g;

% [fSol(t) gSol(t)] = dsolve(eqn1, eqn2, c1, c2);
% [fSol(t) gSol(t)] = dsolve(eqn1, eqn2);

ezplot(fSol) %,'Color','r')
colormap([0 0 1]);
hold on
h=ezplot(gSol); %,'Color','b')

set(h, 'Color', 'r');	
grid on
legend('fSol','gSol','Location','best')