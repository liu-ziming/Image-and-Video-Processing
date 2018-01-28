



- Do a basic implementation of JPEG:

1. Divide the image into non-overlapping 8x8 blocks.

2. Compute the DCT (discrete cosine transform) of each block. This is implemented in popular packages such as Matlab.

3. Quantize each block. You can do this using the tables in the video or simply divide each coefficient by N, round the result to the nearest integer, and multiply back by N. Try for different values of N.

   TIP:量化时不能用课上用的那么大的量化表，因为灰色图像颜色很浅了，会把所有的系数都量化成 0

4. You can also try preserving the 8 largest coefficients (out of the total of 8x8=64), and simply rounding them to the closest integer.

5. Visualize the results after inverting the quantization and the DCT.

```matlab
clc
clear
A=imread('C:\Users\liu-z\Desktop\background.jpg');
I=rgb2gray(A); %转为灰度图
%A=imresize(A,[256,200]);
%imwrite(A,'C:\Users\liu-z\Desktop\start.jpg');
I=im2double(I); %转双精度
T=dctmtx(8); %返回一个8*8的DCT变换矩阵
B=blkproc(I,[8 8],'P1*x*P2',T,T');  %对每个8*8 做DCT变换

b=[1 1 1 1 2 3 4 5;
    1 1 1 2 3 4 5 6;
    1 1 2 3 4 5 6 7 ;
    1 2 3 4 5 6 7 8;
    2 3 4 5 6 7 8 9;
    3 5 5 5 6 6 6 7
    8 8 8 8 8 8 8 8 
    9 9 9 9 9 9 9 9];
B3=blkproc(B,[8 8],'x./P1',b);
B3=int8(B3);
B4=blkproc(double(B3),[8 8],'x.*P1',b);
I2=blkproc(B4,[8 8],'P1*x*P2',T',T);%反DCT变换
subplot(2,2,1),imshow(I);
title('原始图像')
subplot(2,2,2),imshow(I2);
title('压缩图像');
subplot(2,2,3),imshow(I-I2);
title('误差');
disp('压缩后图像I2大小');whos('I2');
disp('压缩后图像I大小');whos('I');
disp('压缩前图像A大小');whos('A');

```

![Snipaste_2018-01-29_00-55-40](C:\Users\liu-z\Desktop\Snipaste_2018-01-29_00-55-40.png)



压缩后图像I2大小
  Name        Size               Bytes  Class     Attributes

  I2        512x512            2097152  double              

压缩后图像I大小
  Name        Size               Bytes  Class     Attributes

  I         512x512            2097152  double              

压缩前图像A大小
  Name        Size                Bytes  Class    Attributes

  A         512x512x3            786432  uint8              





- Repeat the above but instead of using the DCT, use the FFT (Fast Fourier Transform).

![Snipaste_2018-01-29_01-00-24](C:\Users\liu-z\Desktop\Snipaste_2018-01-29_01-00-24.png)



- Repeat the above JPEG-type compression but don’t use any transform, simply perform quantization on the original image.

![Snipaste_2018-01-29_01-03-35](C:\Users\liu-z\Desktop\Snipaste_2018-01-29_01-03-35.png)

- Do JPEG now for color images. In Matlab, use the **rgb2ycbcr** command to convert the *Red-Green-Blue image* to a *Lumina and Chroma one*; then perform the JPEG-style compression on each one of the three channels independently. After inverting the compression, invert the color transform and visualize the result. While keeping the compression ratio constant for the Y channel, increase the compression of the two chrominance channels and observe the results.

  PS: YUV和YCbCr 差不多

```matlab
%对彩色图像压缩
%PS:matlab读取保存一次图像对图像有压缩的效果
RGB=imread('C:\Users\liu-z\Desktop\background.jpg');
R=RGB(:,:,1);
G=RGB(:,:,2);
B=RGB(:,:,3);
subplot(2,2,1);imshow(RGB),title('原始图像');

%RGB->YUV
Y=0.299*double(R)+0.587*double(G)+0.114*double(B);
U=0.169*double(R)-0.3316*double(G)+0.5*double(B);
V=0.5*double(R)-0.4186*double(G)-0.0813*double(B);
YUV=cat(3,Y,U,V); %YUV图像
subplot(2,2,2);imshow(uint8(YUV));title('YUV图像');

T=dctmtx(8);

%DCT变换
BY=blkproc(Y,[8 8],'P1*x*P2',T,T');
BU=blkproc(U,[8 8],'P1*x*P2',T,T');
BV=blkproc(V,[8 8],'P1*x*P2',T,T');
%量化表
a=[16 11 10 16 24 40 51 61;  
      12 12 14 19 26 58 60 55;  
      14 13 16 24 40 57 69 55;  
      14 17 22 29 51 87 80 62;  
      18 22 37 56 68 109 103 77;  
      24 35 55 64 81 104 113 92;  
      49 64 78 87 103 121 120 101;  
      72 92 95 98 112 100 103 99;];  %低频
    
  b=[17 18 24 47 99 99 99 99;  
      18 21 26 66 99 99 99 99;  
      24 26 56 99 99 99 99 99;  
      47 66 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
      99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;  
       99 99 99 99 99 99 99 99;];  %高频
%向量化
  BY=blkproc(BY,[8 8],'x./P1',a);
  BU=blkproc(BU,[8 8],'x./P1',b);
  BV=blkproc(BV,[8 8],'x./P1',b);
  BY=int8(BY);
  BU=int8(BU);
  BV=int8(BV);
  
  %反向量化
  BY=blkproc(BY,[8 8],'x.*P1',a);
  BU=blkproc(BU,[8 8],'x.*P1',b);
  BV=blkproc(BV,[8 8],'x.*P1',b);
  
  mask=[    %保留了所有系数
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;  
         1 1 1  1 1 1 1 1;];  
     %BY BU BV是double类型  
     BY=blkproc(BY,[8 8],'P1.*x',mask);  
     BU=blkproc(BU,[8 8],'P1.*x',mask);  
     BV=blkproc(BV,[8 8],'P1.*x',mask);  
          
     %YI UI VI是double类型  %DCT反变换
     YI=blkproc(double(BY),[8 8],'P1*x*P2',T',T);  
     UI=blkproc(double(BU),[8 8],'P1*x*P2',T',T);  
     VI=blkproc(double(BV),[8 8],'P1*x*P2',T',T);
     
     IYUV=cat(3,YI,UI,VI);%压缩后的图像IYUV
     IYUV=uint8(IYUV);
     subplot(2,2,3);imshow(IYUV),title('压缩后的YUV图像');
     
    %YUV->RGB
    RI=YI-0.001*UI+1.402*VI;
    GI=YI-0.344*UI-0.714*VI;
    BI=YI+1.772*UI+0001*VI;
    IRGB=cat(3,RI,GI,BI);
    IRGB=uint8(IRGB);
   subplot(2,2,4);imshow(IRGB),title('压缩后的图像RGB图像');
     
    
```

![Snipaste_2018-01-29_01-49-58](C:\Users\liu-z\Desktop\Snipaste_2018-01-29_01-49-58.png)



误差说明![Snipaste_2018-01-29_02-09-50](C:\Users\liu-z\Desktop\Snipaste_2018-01-29_02-09-50.png)



>> RGBcompression
>> 压缩后图像IRGB大小
>>
>>   Name        Size                Bytes  Class    Attributes

  IRGB      512x512x3            786432  uint8              

压缩前图像YUV大小
  Name        Size                Bytes  Class    Attributes

  YUV       512x512x3            786432  uint8              

压缩前图像RGB大小
  Name        Size                Bytes  Class    Attributes

  RGB       512x512x3            786432  uint8   



- Compute the histogram of a given image and of its prediction errors. If the

1. pixel being processed is at coordinate (0,0), consider
2. predicting based on just the pixel at (-1,0);
3. predicting based on just the pixel at (0,1);
4. predicting based on the average of the pixels at (-1,0), (-1,1), and (0,1).





- Compute the entropy for each one of the predictors in the previous exercise. Which predictor will compress better?



