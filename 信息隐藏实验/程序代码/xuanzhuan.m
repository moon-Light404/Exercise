P1=imread('result.bmp');
P1=imrotate(P1,90);% 逆时针旋转90度
imwrite(P1,'result_xuanzhuan90.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('原始嵌入水印的图像');
subplot(1,2,2);imshow('result_xuanzhuan90.bmp');title('旋转后的嵌入水印图像');