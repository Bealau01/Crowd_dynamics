function [pos,vel] = check_bordi(N,limiti,x,v)

% For all agents, check domain boundaries
    for i = 1:N
        % Bounce effect if the agent hits left or right wall
        if x(i,1) < limiti(1) % left wall
            x(i,1) = limiti(1);
            v(i,1) = -v(i,1); 
        elseif x(i,1) > limiti(2) % right wall
            x(i,1) = limiti(2);
            v(i,1) = -v(i,1);
        end

        % Pac-man effect if the agent goes above or below
        if x(i,2) < limiti(1) % bottom
            x(i,2) = limiti(2);  % Reappear at top
        elseif x(i,2) > limiti(2) % top
            x(i,2) = limiti(1);  % Reappear at bottom
        end
    end

    pos = x;
    vel = v;
