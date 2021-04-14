function y=Integrator_old(t,x,a,b,g,d,ep,n,mor,modo1,modo2,modo3)



% Velocidades
y(1,1)=x(4,1);
y(2,1)=x(5,1);
y(3,1)=x(6,1);
% Acelerações
y(4,1)=-a(1)*x(4,1)-(d(1)+ep(1)*cos(n*t))*x(1,1)-a(2)*x(2,1)-a(3)*x(1,1)^3-a(4)*x(1,1)*x(2,1)^2-a(5)*x(1,1)*x(3,1)^2 ...
    -mor*(modo1*((x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3).*abs(x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3))');
y(5,1)=-b(1)*x(5,1)-(d(2)+ep(2)*cos(n*t))*x(2,1)-b(2)*x(3,1)-b(3)*x(1,1)-b(4)*x(2,1)*x(1,1)^2-b(5)*x(2,1)^3-b(6)*x(2,1)*x(3,1)^2 ...
    -mor*(modo2*((x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3).*abs(x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3))');
y(6,1)=-g(1)*x(6,1)-(d(3)+ep(3)*cos(n*t))*x(3,1)-g(2)*x(2,1)-g(3)*x(3,1)*x(2,1)^2-g(4)*x(3,1)*x(1,1)^2-g(5)*x(3,1)^3 ...
    -mor*(modo3*((x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3).*abs(x(4,1)*modo1+x(5,1)*modo2+x(6,1)*modo3))');

end

