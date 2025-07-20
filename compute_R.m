function R = compute_R(x,x1,gamma,r)

b = check_ball(x1,x,r); % b=0 means it's inside

if b==0 && norm(x-x1)>0 % if x1 belongs to the ball of radius r centered at x minus {x}
    R = exp(-(norm(x1-x))^gamma) * ((x1-x)/norm(x1-x));
else
    R=0;
end
