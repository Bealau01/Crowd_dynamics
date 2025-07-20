function dv = compute_dv(x,v,y,w,target,r_target)

C_Fr = 0.7; % Repulsive force between agents (both follower-follower and follower-leader)
C_Fal = 3.5;  % Alignment force among followers (they imitate the velocity of their neighbors)
C_Lal = 4;  % Alignment force of followers towards the leaders
C_at = 0.15; % Direct attraction towards visible leaders (only if leaders are "recognizable", otherwise 0)

r = 1; %%%%%%%
gamma = 1; % Controls how fast the interaction force decreases with distance
N = 15; % Number of neighbors considered

[Nf,~] = size(x);
[Nl,~] = size(y);

dv = zeros(Nf,2);

for i = 1:Nf
    xi = x(i,:); 
    vi = v(i,:);

    A = compute_A(xi,vi,target,r_target);
    HF = compute_HF(xi,vi,x,v,y,i,Nf,C_Fr,C_Fal,r,gamma,target,r_target,N); % pass i to remove i-th row from interactions
    HL = compute_HL(xi,vi,x,y,w,Nl,C_Fr,C_Lal,C_at,r,gamma,target,r_target,N); 

    dv(i,:) = A + HF + HL;
end
