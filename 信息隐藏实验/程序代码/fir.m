clear;
img_hidden=imread('dingjun.jpg');
img_hidden=rgb2gray(img_hidden);
imwrite(img_hidden,'dingjun.bmp');
    
img=imread('source.jpg');
img=rgb2gray(img);% ��RGBͼ��ת��Ϊ�Ҷ�ͼ
imwrite(img,'source.bmp');% ���Ҷ�ͼ����

img_f=img;
 
[row_h,col_h]=size(img_hidden);
[row,col]=size(img);
 

%��ͼ��ֿ飬����ÿһ�����ֵ
for i=1:row_h/8
   for j=1:col_h/8
       block=img((i-1)*8+1:i*8,(j-1)*8+1:j*8,:);
       block_h=img_hidden((i-1)*8+1:i*8,(j-1)*8+1:j*8,:);
       e(i,j)=entropy(block);
       e_h(i,j)=entropy(block_h);
   end
end

%����ֵ������н�ά��Ȼ��������
e=e(:);
e_h=e_h(:);
[e,I]=sort(e,'descend');
[e_h,I_h]=sort(e_h,'descend');
 
%����ͼ�񽵼��ķ�������ˮӡͼ������ֵ�ߵ�ͼ���������ԭͼ����ֵ�ߵ�ͼ�����
for i=1:length(I)
    r=mod(I(i),50);
    if r==0
        r=50;
    end
    r_h=mod(I_h(i),50);
    if r_h==0
        r_h=50;
    end
    c=floor(I(i)/50)+1;
    if c==51
        c=50;
    end
    c_h=floor(I_h(i)/50)+1;
    if c_h==51
        c_h=50;
    end
    block=img((r-1)*8+1:r*8,(c-1)*8+1:c*8,:);
    block_h=img_hidden((r_h-1)*8+1:r_h*8,(c_h-1)*8+1:c_h*8,:);
    [x,y]=size(block);
    img_t=block;
    for a=1:x
        for b=1:y
            tmp=dec2bin(block(a,b),8);
            tmp_h=dec2bin(block_h(a,b),8); 
            tmp(5:8)=tmp_h(1:4);
            img_t(a,b)=bin2dec(tmp);
        end
    end
    img_f((r-1)*8+1:r*8,(c-1)*8+1:c*8)=img_t;
end
 
imwrite(img_f,'result.bmp');
%����ͼ����滻��˳��
save('I.mat','I');
save('I_h.mat','I_h');
 
figure;
subplot(1,3,1);imshow('source.bmp');title('ԭʼͼ��');
subplot(1,3,2);imshow('dingjun.bmp');title('ˮӡͼ��');
subplot(1,3,3);imshow('result.bmp');title('Ƕ��ˮӡͼ��');