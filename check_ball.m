% Returns a boolean: b = 0 if point P is inside the ball centered at C with radius r,
% otherwise b = 1

function b = check_ball(P,C,r)

d = norm(P - C);

if d <= r % if inside
    b = 0;
else % if not inside
    b = 1;
end
