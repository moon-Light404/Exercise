P2=imread('result.bmp');
P2=imresize(P2,0.8);
imwrite(P2,'result_yasuo0.8.bmp');
 
figure;
subplot(1,2,1);imshow('result.bmp');title('ԭ����ͼ��');
subplot(1,2,2);imshow('result_yasuo0.8.bmp');title('ѹ���������ͼ��');
