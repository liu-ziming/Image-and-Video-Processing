clc
clear
A=imread('C:\Users\liu-z\Desktop\background.jpg');
I=rgb2gray(A); %תΪ�Ҷ�ͼ
%A=imresize(A,[256,200]);
%imwrite(A,'C:\Users\liu-z\Desktop\start.jpg');
I=im2double(I); %ת˫����
%T=fft(8); %����һ��8*8��DCT�任����
%B=blkproc(I,[8 8],'P1*x*P2',T,T');  %��ÿ��8*8 ��DCT�任

b=[1 1 1 1 2 3 4 5;
    1 1 1 2 3 4 5 6;
    1 1 2 3 4 5 6 7 ;
    1 2 3 4 5 6 7 8;
    2 3 4 5 6 7 8 9;
    3 5 5 5 6 6 6 7
    8 8 8 8 8 8 8 8 
    9 9 9 9 9 9 9 9];
B3=blkproc(I,[8 8],'x./P1',b);
B3=int8(B3);
B4=blkproc(double(B3),[8 8],'x.*P1',b);
%I2=blkproc(B4,[8 8],'P1*x*P2',T',T);%��DCT�任
subplot(2,2,1),imshow(I);
title('ԭʼͼ��')
subplot(2,2,2),imshow(B4);
title('ѹ��ͼ��');
subplot(2,2,3),imshow(I-B4);
title('���');
disp('ѹ����ͼ��I2��С');whos('I2');
disp('ѹ����ͼ��I��С');whos('I');
disp('ѹ��ǰͼ��A��С');whos('A');


