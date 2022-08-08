P2=imread('result.bmp');
P2=imresize(P2,0.8);
imwrite(P2,'result_yasuo0.8.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('原载体图像');
subplot(1,2,2);imshow('result_yasuo0.8.bmp');title('压缩后的载体图像');
