function sHL = compute_HL(xi,vi,x,y,w,Nl,C_Fr,C_Lal,C_at,r,gamma,target,r_target,N)

%Follower-leader interactions

HL=zeros(Nl,2);


for j=1:Nl

    yj=y(j,:);
    wj=w(j,:);

    R=compute_R(xi,yj,gamma,r);
    theta=check_ball(xi,target,r_target);
    [~,Nstar,r_neigh]=find_neighbors(x,y,xi,N);
    car=check_ball(yj,xi,r_neigh);
    car=~car;

    HL(j,:) = -C_Fr*R + theta*(C_Lal/Nstar)*(wj-vi)*car + theta*C_at*((yj-xi)/(norm(yj-xi)));

end

sHL=sum(HL,1);