function [t,a1,a2,a3,g1,g2,g3] = identifystep(X, Acc_threshold, Stride_time_up_threshold, Stride_time_low_threshold)
t = [];
a1 = [];
a2 = [];
a3 = [];
g1 = [];
g2 = [];
g3 = [];
%initialize step start vector
stepstart = [];
Euler = qua2eul(X(:,5:8));
%calculate resultant acc
for i = 1:1:size(X,1)
ACC_Result(i) = sumsqr(X(i,2:4));
end
%find acc that greater than threshold m/s^2
ACC_high = find(ACC_Result > Acc_threshold);
stepstart(1) = ACC_high(1);
stepnum = 2;
%find available step start
for i = 2:1:size(ACC_high,2)
    if ACC_high(i) - ACC_high(i-1) > Stride_time_up_threshold * 100
        stepstart(stepnum) = ACC_high(i);
        stepnum = stepnum + 1;
    end
end
%extract matrix for ML algorithm
rownum = 0;
for i = 2:1:size(stepstart,2)
    %find valid step
    if stepstart(i) - stepstart(i-1) < Stride_time_low_threshold*100
        rownum = rownum + 1;
        t(rownum) = stepstart(i) - stepstart(i-1);
        %normalize gait data
        T = 1:(99/t(rownum)):100;
        Nor_T = 1:1:100;
        a1(:,rownum) = interp1(T,X(stepstart(i-1):stepstart(i),2),Nor_T);
        a2(:,rownum) = interp1(T,X(stepstart(i-1):stepstart(i),3),Nor_T);
        a3(:,rownum) = interp1(T,X(stepstart(i-1):stepstart(i),4),Nor_T);
        g1(:,rownum) = interp1(T,Euler(stepstart(i-1):stepstart(i),1),Nor_T);
        g2(:,rownum) = interp1(T,Euler(stepstart(i-1):stepstart(i),2),Nor_T);
        g3(:,rownum) = interp1(T,Euler(stepstart(i-1):stepstart(i),3),Nor_T);
    end
end