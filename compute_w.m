function dy = compute_w(x,y,target)

r=1;%%%%%%%%%%
zeta=1; % Same role as gamma, but in a more specific context for leaders.
C_Lr=0.4; % Repulsive force between leaders
alpha=0.7;

[Nf,~]=size(x);
[Nl,~]=size(y);

dy=zeros(Nl,2);
u=zeros(Nl,2);

for i=1:Nl
   B=0.3*randn(1,2); % small perturbation
   ui=target-y(i,:) + B; % go-to-target + perturbation
   u(i,:)=alpha*ui/norm(ui); % normalize velocity and reduce alpha (make them slower to interact more with followers)
end

for i=1:Nl
    yi=y(i,:);
    ui=u(i,:);

    KF=compute_KF(x,yi,Nf,zeta,r,C_Lr);
    KL=compute_KL(y,yi,i,Nl,zeta,r,C_Lr);
    
    dy(i,:) = KF + KL + ui; 
end
