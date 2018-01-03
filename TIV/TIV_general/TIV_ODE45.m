clear;
close;

options = odeset('RelTol',1e-6,'AbsTol',[1e-6 1e-6 1e-6 1e-1]);

% [T,Y] = ode45(@TIV_ODE,[0 10],[2e-5 1e12 1e12 40e6],options);
%[T,Y] = ode45(@TIV_ODE,[0 10],[1e-6 1e12 1e13 5e7],options);
plot(T,Y(:,2),'-.',T,Y(:,3),'.')
figure
plot(T,Y(:,4),'*')
figure
plot(T,Y(:,1),'-')


