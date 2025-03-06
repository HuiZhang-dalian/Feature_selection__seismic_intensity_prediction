function vel = acc2vel(acc, dt)
n = length(acc);
vel = zeros(n,1);
vel(1,1) = 0;
for i=2:n
    vel(i, 1) = vel(i-1, 1) + acc(i-1, 1) * dt / 2 + acc(i, 1) * dt / 2;
end