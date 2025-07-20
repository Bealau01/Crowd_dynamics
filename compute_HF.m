function sHF = compute_HF(xi,vi,x,v,y,i,Nf,C_Fr,C_Fal,r,gamma,target,r_target,N)

% Follower-follower interactions

HF=zeros(Nf-1,2);

% Remove the i-th row (xi,vi) from x and v
x(i,:)=[];
v(i,:)=[];

for j=1:Nf-1

    xj=x(j,:);
    vj=v(j,:);

    R=compute_R(xi,xj,gamma,r);
    theta=check_ball(xi,target,r_target);
    [~,Nstar,r_neigh]=find_neighbors(x,y,xi,N);
    car=check_ball(xj,xi,r_neigh);
    car=~car;

    HF(j,:) = -C_Fr*R + theta*(C_Fal/Nstar)*(vj-vi)*car;

end

sHF=sum(HF,1);
