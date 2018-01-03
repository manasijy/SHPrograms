clear;
close;

options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-5 1e-4]);
[T,Y] = ode45(@TIV_ODE,[0 10],[1e-6 1e12 1e13 5e7],options);
plot(T,Y(:,1),'-',T,Y(:,2),'-.',T,Y(:,3),'.',T,Y(:,4),'*')
figure
plot(T,Y(:,1),'-')
