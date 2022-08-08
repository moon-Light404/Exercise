% 椒盐噪声攻击
P = imread('result.bmp');
P1 = imnoise(P, 'salt & pepper', 0.1);
P2 = imnoise(P, 'salt & pepper', 0.3);
P3 = imnoise(P, 'salt & pepper', 0.5);
imwrite(P1, 'jiaoyan1.bmp');
imwrite(P2, 'jiaoyan2.bmp');
imwrite(P3, 'jiaoyan3.bmp');

% P5=imread('result.bmp');
% P5=imnoise(P5,'gaussian',0.0001,0.0001);% 给图像加高斯噪声
% imwrite(P5,'noise0.0001.bmp');
%  
% figure;
% subplot(1,2,1);imshow('result.bmp');title('原载体图像');
% subplot(1,2,2);imshow('noise0.0001.bmp');title('加入噪声后的载体图像');