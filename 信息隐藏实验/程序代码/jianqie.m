% ���й���
P3=imread('result.bmp');
P3(1:350,1:300)=256;% ����
imwrite(P3,'result_jianqie3.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('ԭ����ͼ��');
subplot(1,2,2);imshow('result_jianqie3.bmp');title('���к������ͼ��');


