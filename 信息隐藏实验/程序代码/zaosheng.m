% ��˹��������
P5=imread('result.bmp');
P5=imnoise(P5,'gaussian',0.001,0.001);% ��ͼ��Ӹ�˹����
imwrite(P5,'result_zaosheng.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('ԭ����ͼ��');
subplot(1,2,2);imshow('result_zaosheng.bmp');title('���������������ͼ��');


