clc
clear all
close all

%seed
%rng(41);

% Parameters
Nf = 100;            % Number of followers
Nl = 3;              % Number of leaders
steps = 1000;        % Number of time steps
limiti = [0,20];     % Omega: 20x20 space
dt = 0.1;            % Time interval
v_max = 0.5;         % Maximum initial speed
w_max = 0.5;
target=[16,16];      % Target point: top-right corner
tol=0.1;

% Visible zone Sigma
r_target = 3;
ang = linspace(0, 2*pi, 100);  % Angles from 0 to 360 degrees in radians
x_circ = target(1) + r_target * cos(ang);
y_circ = target(2) + r_target * sin(ang);
%--------------------------------------------------------------------------

% Initialize positions and velocities
x = rand(Nf, 2) * limiti(2);   % Initial positions in [0,20] for followers
y = rand(Nl, 2) * limiti(2);   % Initial positions in [0,20] for leaders
%v=zeros(Nf,2);
%w=zeros(Nl,2);
v = (rand(Nf,2)-0.5) * v_max;  % Initial velocities for followers in [-0.5*v_max, 0.5*v_max]
w = (rand(Nl,2)-0.5) * w_max;  % Initial velocities for leaders in [-0.5*v_max, 0.5*v_max]

%--------------------------------------------------------------------------
% Setup figure
figure;
h1 = scatter(x(:,1), x(:,2), 'filled');
hold on
h2 = scatter(y(:,1),y(:,2),'red','filled');
axis equal; axis manual;
xlim(limiti); ylim(limiti);
title('Points');
hold on
plot(target(1), target(2), '*g', 'MarkerSize', 10, 'LineWidth', 2);
hold on
plot(x_circ, y_circ, 'g--', 'LineWidth', 2);  
%--------------------------------------------------------------------------

Nf_init = Nf;
Nl_init = Nl;

%filename = 'prova1.gif';  % GIF file name

% Snapshot of positions and counters
x_snap1 = x;   y_snap1 = y;     Nf1 = Nf;     Nl1 = Nl;   % t = 0

bool=0;
%--------------------------------------------------------------------------
% Time loop
for t = 1:steps
    if Nf == 0 && Nl == 0
        fprintf('All agents arrived, simulation stopped at time: %d',t);
        bool=1;
        break;
    end
    
    % Update velocity
    u = compute_dv(x,v,y,w,target,r_target);
    v = v+u*dt; % Euler method
    w = compute_w(x,y,target);

    % Update position - Euler method
    x = x+v*dt;
    y = y+w*dt;

    % Boundary check
    [x,v] = check_bordi(Nf,limiti,x,v);
    [y,w] = check_bordi(Nl,limiti,y,w);

    % Save data at selected time steps
    if t == round(steps/3)
        x_snap2 = x;
        y_snap2 = y;
        Nf2 = Nf;
        Nl2 = Nl;
    elseif t == round(2*steps/3)
        x_snap3 = x;
        y_snap3 = y;
        Nf3 = Nf;
        Nl3 = Nl;
     end

    % Check followers
    if Nf > 0
        distanza = vecnorm(x - target, 2, 2);  % Euclidean distance row by row
        mask_keep = distanza >= tol;          % true if not at target
        x = x(mask_keep,:);
        v = v(mask_keep,:);
        Nf = size(x,1);       
    end
    
    % Check leaders
    if Nl > 0
        distanzaL = vecnorm(y - target, 2, 2);
        mask_keepL = distanzaL >= tol;
        y = y(mask_keepL,:);
        w = w(mask_keepL,:);
        Nl = size(y,1);
    end

    % Update plot
    set(h1, 'XData', x(:,1), 'YData', x(:,2));
    set(h2, 'XData', y(:,1), 'YData', y(:,2));
    drawnow;
    
    f_arrivati = Nf_init - Nf;
    l_arrivati = Nl_init - Nl;
    titolo = sprintf('Time t = %.1f s | Followers arrived: %d | Leaders arrived: %d', t*dt, f_arrivati, l_arrivati);
    title(titolo);

    %---------------------------------------------------------------------------------------
    % GIF saving
    %frame = getframe(gcf);            % capture figure frame
    %img = frame2im(frame);            % convert to image
    %[imind, cm] = rgb2ind(img, 256);  % convert to GIF format 
    
    %if t == 1
    %    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05); % first frame
    %else
    %    imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05); % append frame
    %end
    %----------------------------------------------------------------------------------------
   
end
%---------------------------------------------------------------------------
x_snap4 = x;
y_snap4 = y;
Nf4 = Nf;
Nl4 = Nl;

% Display how many followers and leaders arrived
if bool==0
    fprintf('Arrived %d followers and %d leaders:',Nf_init-Nf,Nl_init-Nl);
end

% Plot snapshots
figure;
Xs = {x_snap1, x_snap2, x_snap3, x_snap4};
Ys = {y_snap1, y_snap2, y_snap3, y_snap4};
Nfs = [Nf1, Nf2, Nf3, Nf4];
Nls = [Nl1, Nl2, Nl3, Nl4];
times = {'t = 0', 't = T/3', 't = 2T/3', 't = T'};

for i = 1:4
    subplot(2,2,i);
    scatter(Xs{i}(:,1), Xs{i}(:,2), 20, 'blue', 'filled'); hold on;
    scatter(Ys{i}(:,1), Ys{i}(:,2), 40, 'red', 'filled');
    plot(target(1), target(2), '*g', 'MarkerSize', 10, 'LineWidth', 2);
    plot(x_circ, y_circ, 'g--', 'LineWidth', 1.2);
    
    axis equal;
    xlim([0 20]);
    ylim([0 20]);

    % Compute number of arrived agents
    f_arr = Nf_init - Nfs(i);
    l_arr = Nl_init - Nls(i);
    
    title(sprintf('%s\nFollowers arrived: %d\nLeaders arrived: %d', ...
        times{i}, f_arr, l_arr), 'FontSize', 10);
end
