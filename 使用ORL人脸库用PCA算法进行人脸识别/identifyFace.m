%face identification algorithm
clc
clear all,global im;
imgdata=[];     %训练图像矩阵
M=200;          %训练图片总数 200张
for i=1:40
    for j=1:5
        a=imread(strcat('C:\Users\liu-z\Desktop\att_faces\s',num2str(i),'\',num2str(j),'.pgm'));
        %imshow(a);
        b=a(1:112*92); %转为列矢量1*N的b ， 其中N=10304，提取顺序是先列后行（从上到下从左到右）
        b=double(b);
        imgdata=[imgdata;b]; %这张图片加到imgdata矩阵，imgdata是一个M*N的矩阵，每一行是一个人的图片5张
    end
end

imgmean=mean(imgdata);
for i=1:M
    xmean(i,:)=imgdata(i,:)-imgmean;  %xmean保存训练图和平均图之差
end
sigma = xmean*xmean'/(M-1);%M*M矩阵，获得协方差矩阵
[v d] = eig(sigma);  %求矩阵sigma的全部特征值，存成对角阵d ； 特征向量存在矩阵 v 中
                    %eig() 返回 归一化的正交特征向量 
d1=diag(d);         %获取d的对角线元素 
[d2 index]=sort(d1);  %升序排列特征值
cols =size(v,2);    %特征向量矩阵的列数
for i=1:cols
    vsort(:,i)=v(:,index(cols-i+1));%降序特征向量
    dsort(i)=d1(index(cols-i+1));%降序特征值
end   %Matlab中给一维向量排序是使用sort函数：sort（X），其中x为待排序的向量。
%若欲保留排列前的索引，则可用[sX,index] = sort(X) ，排序后，sX是排序好的向量，
%index是 向量sX中对X 的索引。 索引使排列逆运算成为可能。事实上，这里X≡sX(index),
%[X恒等于sX(index)]，这个结论确实很奇妙，而且很有用。???

%以上完成了提取协方差矩阵的特征向量特征值并排序好
%接下来选择 90 % 的能量??到第p个向量
dsum = sum(dsort);
dsum_get = 0;
p=0;
while(dsum_get/dsum <= 0.9)
    p=p+1;
    dsum_get = sum(dsort(1:p));
end
i=1;
%训练阶段
%计算特征脸形成的坐标系
i=1;
while(i<=p&&dsort(i)>0)
    base(:,i)=dsort(i)^(-1/2)*xmean'*vsort(:,i)  %SDV
    i=i+1;
end
%base 是N*p的矩阵；
% dsort的-1/2次方标准化人脸图像
% xmean*vsort(:,i) 小矩阵的特征向量向大矩阵特征向量转化的过程】？？
%将训练样本对新坐标系投影 得到N*p的矩阵作为参考
reference = xmean*base;

%在测试图片中选择图片，进行人脸检测
test_a=imread('C:\Users\liu-z\Desktop\att_faces\9.pgm');
test_b=test_a(1:112*92);
test_b=double(test_b);
%计算其和均值图的差图  在残差子空间的投影
object = (test_b-imgmean)*base;% 1*p的矩阵
subplot(1,2,1);imshow(test_a);title('testimg');
%对待测图进行规范化 
distance = norm(object-reference(1,:)); %归一化
%最小距离法 ， 寻找与待测图最接近的人脸（训练集中）
for num1= 1:40
    for num2=1:5
        temp = norm(object-reference((num1-1)*5+num2,:));%待测图 投影与参考 之间的距离
        if(temp<distance)
            k=num1;   %匹配到的是 k 号同学
            distance=temp; %不断缩小范围找到最接近的那一个
        end
    end
end

fprintf('此图为第%d个人的图片\n',k);
P = imread(strcat('C:\Users\liu-z\Desktop\att_faces\s',num2str(k),'\',num2str(1),'.pgm'));
subplot(1,2,2);imshow(P);title('matchimg');



            
