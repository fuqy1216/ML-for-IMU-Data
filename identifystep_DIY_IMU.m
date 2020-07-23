function [t,a1,a2,a3,g1,g2,g3] = identifystep_DIY_IMU(X, Acc_threshold, Stride_time_up_threshold, Stride_time_low_threshold)
t = [];
a1 = [];
a2 = [];
a3 = [];
g1 = [];
g2 = [];
g3 = [];
%reorganize X
X(:,2:4) = X(:,2:4)/9.8;
TEMP(:,1) = X(:,1);
TEMP(:,2:4) = X(:,5:7)/180*pi;
TEMP(:,2) = TEMP(:,2) - pi;
TEMP(:,5) = X(:,2);
TEMP(:,6) = X(:,4);
TEMP(:,7) = X(:,3);
X = TEMP;
%initialize step start vector
stepstart = [];
%calculate resultant acc
for i = 1:1:size(X,1)
ACC_Result(i) = sumsqr(X(i,5:7));
end
%find acc that greater than threshold m/s^2
ACC_high = find(ACC_Result > Acc_threshold);
stepstart(1) = X(ACC_high(1),1);
stepnum = 2;
%find available step start
for i = 2:1:size(ACC_high,2)
    if X(ACC_high(i),1) - X(ACC_high(i-1),1) > Stride_time_up_threshold * 80
        stepstart(stepnum) = X(ACC_high(i),1);
        stepnum = stepnum + 1;
    end
end
%extract matrix for ML algorithm
rownum = 0;
for i = 2:1:size(stepstart,2)
    %find valid step
    if stepstart(i) - stepstart(i-1) < Stride_time_low_threshold*120
        rownum = rownum + 1;
        t(rownum) = stepstart(i) - stepstart(i-1);
        %normalize gait data
        T = X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),1);
        T = (T - X(find(X(:,1)==stepstart(i-1)),1))/(X(find(X(:,1)==stepstart(i)),1)-X(find(X(:,1)==stepstart(i-1)),1))*99;
        Nor_T = 0:1:99;
        g1(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),2),Nor_T);
        g2(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),3),Nor_T);
        g3(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),4),Nor_T);
        a1(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),5),Nor_T);
        a2(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),6),Nor_T);
        a3(:,rownum) = interp1(T,X(find(X(:,1)==stepstart(i-1)):find(X(:,1)==stepstart(i)),7),Nor_T);
    end
end