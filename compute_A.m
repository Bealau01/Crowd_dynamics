function A = compute_A(xi,vi,target,r_target)

% Individual tendency

sigma = 2;                     % standard deviation
z = sigma * randn(1,2);        % 1x2 vector from N(0, sigma^2)
C_z = 1;        % Noise: how much the follower moves randomly, outside the visible area
C_tau = 1;      % Tendency of the follower to move towards the target, if inside the visible area
C_s = 0.7;      % Speed regulation (tendency to maintain a desired speed s)
s = sqrt(1.4);  % Desired speed of the follower

theta = check_ball(xi,target,r_target);

A = theta*C_z*(z-vi) + (1-theta)*C_tau*((target-xi)/norm(target-xi)-vi) + C_s*(s^2-norm(vi)^2)*vi;
