clear all;
start_time=cputime;
cover_object=imresize(imread('cam.png'),[256,256]);
[row,col]=size(cover_object);
M=row;
N=col;
MN=col*row;
%%%����ԭʼˮӡ%%%%%
m=imresize(imread('nd.png'),[256,256]);%!!!
for i=1:256
   for j=1:256
      if double(m(i,j))==0
         w(i,j)=0;
      else 
         w(i,j)=1;
      end
   end
end

%%%ˮӡ��Ϣ��Ƕ��%%%%%
s=cover_object;
for i=1:256
   for j=1:256
      s(i,j)=bitset(cover_object(i,j),1,w(i,j)); %%weizhi=3,��Խ��ˮӡԽ����%%
   end                                          %%��ԽС��ˮӡԽģ���������Чλ��������
end
imwrite(s,'lsb_watermarkedx.bmp');


figure(1)
subplot(1,2,1);
imshow(s,[]);
title('Ƕ��ˮӡͼ��')
subplot(1,2,2);
imshow(cover_object,[])
title('ԭͼ��')

%����PSNR
A=s;X=cover_object;
[height width]=size(X);
X=double(X);
A=double(A);
sigma1=0;
for i=1:height
for j=1:width
sigma1=sigma1+(X(i,j)-A(i,j))^2;
end
end
mse=(sigma1/(height*width));   %�������
psnr=10*log10((255^2)/mse)

%tiqv
file_name='hb.png';
orig_watermark=imread(file_name);
for i=1:256
   for j=1:256
      mm(i,j)=bitget(uint8(s(i,j)),1);
      if double(mm(i,j))==1
         mm(i,j)=255;
      else
         mm(i,j)=0;
      end
   end
end
%err=sum(sum(xor(m,mm)))/(256*256),

%��ʾ����ʱ��
elapsed_time=cputime-start_time,

figure(3)
subplot(1,2,1);
imshow(uint8(mm));
title('��ȡˮӡͼ��');
subplot(1,2,2);
imshow(orig_watermark,[])
title('ԭʼˮӡ')
