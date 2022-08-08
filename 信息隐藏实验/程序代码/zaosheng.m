% 高斯噪声攻击
P5=imread('result.bmp');
P5=imnoise(P5,'gaussian',0.001,0.001);% 给图像加高斯噪声
imwrite(P5,'result_zaosheng.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('原载体图像');
subplot(1,2,2);imshow('result_zaosheng.bmp');title('加入噪声后的载体图像');


