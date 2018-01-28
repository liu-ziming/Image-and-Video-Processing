clc
clear
A=imread('C:\Users\liu-z\Desktop\background.jpg');
I=rgb2gray(A); %转为灰度图
%A=imresize(A,[256,200]);
%imwrite(A,'C:\Users\liu-z\Desktop\start.jpg');
I=im2double(I); %转双精度
%T=fft(8); %返回一个8*8的DCT变换矩阵
%B=blkproc(I,[8 8],'P1*x*P2',T,T');  %对每个8*8 做DCT变换

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
%I2=blkproc(B4,[8 8],'P1*x*P2',T',T);%反DCT变换
subplot(2,2,1),imshow(I);
title('原始图像')
subplot(2,2,2),imshow(B4);
title('压缩图像');
subplot(2,2,3),imshow(I-B4);
title('误差');
disp('压缩后图像I2大小');whos('I2');
disp('压缩后图像I大小');whos('I');
disp('压缩前图像A大小');whos('A');


