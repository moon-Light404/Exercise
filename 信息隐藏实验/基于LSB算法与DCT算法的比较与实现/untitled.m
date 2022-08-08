clc
clear all;
 
I = imread('1.bmp');
 
Aimage1=I;
Wnoise=uint8(20*randn(size(Aimage1)));
%Wnoise=20*randn(size(Aimage1),'like',wimage);
Aimage1=Aimage1+Wnoise;
subplot(2,3,1),imshow(Aimage1,[]),title('������������ͼ��');
 
% ��˹��ͨ�˲� 
Aimage2=I;
H=fspecial('gaussian',[4,4],0.5);
Aimage2=imfilter(Aimage2,H);
subplot(2,3,2),imshow(Aimage2,[]),title('��˹��ͨ�˲����ͼ��');
    
% ���й��� 
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
% ����ǻҶ�ͼ��
if dimension == 2
    Aimage3(1:128,1:128)=256;
end
subplot(2,3,3),imshow(Aimage3,[]),title('���к��ͼ��');
 
% ��ת���� 
Aimage4=I;
Aimage4=imrotate(Aimage4,10,'bilinear','crop');
Aimage_4=mat2gray(Aimage4);
subplot(2,3,4),imshow(Aimage_4,[]),title('��ת10 �Ⱥ��ͼ��');
 
 % û���ܵ����� 
subplot(2,3,5),imshow(I,[]),title('�޹���ͼ��');