function sKF = compute_KF(x,yi,Nf,zeta,r,C_Lr)

%Leader-follower interactions

KF=zeros(Nf,2);

for j=1:Nf
    xj=x(j,:);
    R=compute_R(yi,xj,zeta,r);
    KF(j,:)=-C_Lr*R;
end

sKF=sum(KF);

