% ������������
P = imread('result.bmp');
P1 = imnoise(P, 'salt & pepper', 0.1);
P2 = imnoise(P, 'salt & pepper', 0.3);
P3 = imnoise(P, 'salt & pepper', 0.5);
imwrite(P1, 'jiaoyan1.bmp');
imwrite(P2, 'jiaoyan2.bmp');
imwrite(P3, 'jiaoyan3.bmp');

% P5=imread('result.bmp');
% P5=imnoise(P5,'gaussian',0.0001,0.0001);% ��ͼ��Ӹ�˹����
% imwrite(P5,'noise0.0001.bmp');
%  
% figure;
% subplot(1,2,1);imshow('result.bmp');title('ԭ����ͼ��');
% subplot(1,2,2);imshow('noise0.0001.bmp');title('���������������ͼ��');