clc
clear all;
 
I = imread('1.bmp');
 
Aimage1=I;
Wnoise=uint8(20*randn(size(Aimage1)));
%Wnoise=20*randn(size(Aimage1),'like',wimage);
Aimage1=Aimage1+Wnoise;
subplot(2,3,1),imshow(Aimage1,[]),title('加入白噪声后的图象');
 
% 高斯低通滤波 
Aimage2=I;
H=fspecial('gaussian',[4,4],0.5);
Aimage2=imfilter(Aimage2,H);
subplot(2,3,2),imshow(Aimage2,[]),title('高斯低通滤波后的图象');
    
% 剪切攻击 
Aimage3=I;
image_size=size(I);
dimension = numel(image_size); 
if dimension == 3
    Aimage3_r = Aimage3(:,:,1);
    Aimage3_r(1:128,1:128)=256;
    Aimage3_g = Aimage3(:,:,2);
    Aimage3_g(1:128,1:128)=256;
    Aimage3_b = Aimage3(:,:,3);
    Aimage3_b(1:128,1:128)=256;
    
    Aimage3(:,:,1) = Aimage3_r;
    Aimage3(:,:,2) = Aimage3_g;
    Aimage3(:,:,3) = Aimage3_b;
end
% 如果是灰度图像
if dimension == 2
    Aimage3(1:128,1:128)=256;
end
subplot(2,3,3),imshow(Aimage3,[]),title('剪切后的图象');
 
% 旋转攻击 
Aimage4=I;
Aimage4=imrotate(Aimage4,10,'bilinear','crop');
Aimage_4=mat2gray(Aimage4);
subplot(2,3,4),imshow(Aimage_4,[]),title('旋转10 度后的图象');
 
 % 没有受到攻击 
subplot(2,3,5),imshow(I,[]),title('无攻击图像');