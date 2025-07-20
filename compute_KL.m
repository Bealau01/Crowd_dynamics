function sKL = compute_KL(y,yi,i,Nl,zeta,r,C_Lr)

%Leader-leader interactions

KL=zeros(Nl-1,2);
y(i,:)=[];

for j=1:Nl-1
    yj=y(j,:);
    R=compute_R(yi,yj,zeta,r);
    KL(j,:)=-C_Lr*R;
end

sKL=sum(KL);

