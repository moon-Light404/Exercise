P1=imread('result.bmp');
P1=imrotate(P1,90);% ��ʱ����ת90��
imwrite(P1,'result_xuanzhuan90.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('ԭʼǶ��ˮӡ��ͼ��');
subplot(1,2,2);imshow('result_xuanzhuan90.bmp');title('��ת���Ƕ��ˮӡͼ��');