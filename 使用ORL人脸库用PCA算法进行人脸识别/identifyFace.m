%face identification algorithm
clc
clear all,global im;
imgdata=[];     %ѵ��ͼ�����
M=200;          %ѵ��ͼƬ���� 200��
for i=1:40
    for j=1:5
        a=imread(strcat('C:\Users\liu-z\Desktop\att_faces\s',num2str(i),'\',num2str(j),'.pgm'));
        %imshow(a);
        b=a(1:112*92); %תΪ��ʸ��1*N��b �� ����N=10304����ȡ˳�������к��У����ϵ��´����ң�
        b=double(b);
        imgdata=[imgdata;b]; %����ͼƬ�ӵ�imgdata����imgdata��һ��M*N�ľ���ÿһ����һ���˵�ͼƬ5��
    end
end

imgmean=mean(imgdata);
for i=1:M
    xmean(i,:)=imgdata(i,:)-imgmean;  %xmean����ѵ��ͼ��ƽ��ͼ֮��
end
sigma = xmean*xmean'/(M-1);%M*M���󣬻��Э�������
[v d] = eig(sigma);  %�����sigma��ȫ������ֵ����ɶԽ���d �� �����������ھ��� v ��
                    %eig() ���� ��һ���������������� 
d1=diag(d);         %��ȡd�ĶԽ���Ԫ�� 
[d2 index]=sort(d1);  %������������ֵ
cols =size(v,2);    %�����������������
for i=1:cols
    vsort(:,i)=v(:,index(cols-i+1));%������������
    dsort(i)=d1(index(cols-i+1));%��������ֵ
end   %Matlab�и�һά����������ʹ��sort������sort��X��������xΪ�������������
%������������ǰ�������������[sX,index] = sort(X) �������sX������õ�������
%index�� ����sX�ж�X �������� ����ʹ�����������Ϊ���ܡ���ʵ�ϣ�����X��sX(index),
%[X�����sX(index)]���������ȷʵ��������Һ����á�???

%�����������ȡЭ��������������������ֵ�������
%������ѡ�� 90 % ������??����p������
dsum = sum(dsort);
dsum_get = 0;
p=0;
while(dsum_get/dsum <= 0.9)
    p=p+1;
    dsum_get = sum(dsort(1:p));
end
i=1;
%ѵ���׶�
%�����������γɵ�����ϵ
i=1;
while(i<=p&&dsort(i)>0)
    base(:,i)=dsort(i)^(-1/2)*xmean'*vsort(:,i)  %SDV
    i=i+1;
end
%base ��N*p�ľ���
% dsort��-1/2�η���׼������ͼ��
% xmean*vsort(:,i) С���������������������������ת���Ĺ��̡�����
%��ѵ��������������ϵͶӰ �õ�N*p�ľ�����Ϊ�ο�
reference = xmean*base;

%�ڲ���ͼƬ��ѡ��ͼƬ�������������
test_a=imread('C:\Users\liu-z\Desktop\att_faces\9.pgm');
test_b=test_a(1:112*92);
test_b=double(test_b);
%������;�ֵͼ�Ĳ�ͼ  �ڲв��ӿռ��ͶӰ
object = (test_b-imgmean)*base;% 1*p�ľ���
subplot(1,2,1);imshow(test_a);title('testimg');
%�Դ���ͼ���й淶�� 
distance = norm(object-reference(1,:)); %��һ��
%��С���뷨 �� Ѱ�������ͼ��ӽ���������ѵ�����У�
for num1= 1:40
    for num2=1:5
        temp = norm(object-reference((num1-1)*5+num2,:));%����ͼ ͶӰ��ο� ֮��ľ���
        if(temp<distance)
            k=num1;   %ƥ�䵽���� k ��ͬѧ
            distance=temp; %������С��Χ�ҵ���ӽ�����һ��
        end
    end
end

fprintf('��ͼΪ��%d���˵�ͼƬ\n',k);
P = imread(strcat('C:\Users\liu-z\Desktop\att_faces\s',num2str(k),'\',num2str(1),'.pgm'));
subplot(1,2,2);imshow(P);title('matchimg');



            
