clear all;
clc;
X = [];
%input X number
load('Dataset.mat')
%initialize parameters
Acc_threshold = 3; %3
Stride_time_up_threshold = 0.9; %0.9
Stride_time_low_threshold = 2; %2
[t,a1,a2,a3,e1,e2,e3] = identifystep_DIY_IMU(X, Acc_threshold, Stride_time_up_threshold, Stride_time_low_threshold);
for i = 1:1:size(a1,2)
Acc_Gyro_temp(:,i) = [t(i);a1(:,i);a2(:,i);a3(:,i);e1(:,i);e2(:,i);e3(:,i)];
end
y_temp(1:size(a1,2)) = 0;%1 for pathological gait, 0 for healthy gait
%t1;a1;a2;a3;e1;e2;e3 unrolled vector
Acc_Gyro = [Acc_Gyro,Acc_Gyro_temp];
y = [y,y_temp];
save('Dataset.mat','Acc_Gyro','y');