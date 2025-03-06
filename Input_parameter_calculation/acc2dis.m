function dis = acc2dis(acc, dt)
n = length(acc);
vel = zeros(n, 1);
dis = zeros(n, 1);
for i=2:n
    vel(i, 1) = vel(i-1, 1) + acc(i-1, 1) * dt / 2 + acc(i, 1) * dt / 2;
    dis(i)=dis(i-1)+dt*vel(i-1)+dt*dt*acc(i-1)/3+dt*dt*acc(i)/6;
end
