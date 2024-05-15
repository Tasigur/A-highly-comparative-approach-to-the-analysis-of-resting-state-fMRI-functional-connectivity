function Behavior_gauss=gauss_transform(Behavior)
% gaussianize Behavior matrix

[n_sub n_meas]=size(Behavior);
Behavior_gauss=zeros(n_sub,n_meas);
lin_space=linspace(0,1,n_sub+2);
lin_space=lin_space(2:end-1);
norm_inv=norminv(lin_space);

for i_meas=1:n_meas
    beh_this=Behavior(:,i_meas);
    [beh_this_sorted ind_sorted]=sort(beh_this);
    norm_inv_rearranged=norm_inv(ind_sorted);
    Behavior_gauss(:,i_meas)=norm_inv_rearranged;
end
