clear all;
start_time=cputime,
cover_boject=imresize(imread('cam.png'),[256,256]);
[row,col]=size(cover_boject);
M=row;
N=col;
MN=col*row;

%%%读入原始水印%%%%%

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

%%%水印信息的嵌入%%%%%
s=cover_boject;
for i=1:256
   for j=1:256
      s(i,j)=bitset(cover_boject(i,j),1,w(i,j)); %%weizhi=3,数越大，水印越明显%%
   end                                          %%数越小，水印越模糊（最低有效位的来历）
end
imwrite(s,'lsb_watermarkedx.png');


figure(1)
subplot(1,2,1);
imshow(s,[]);
title('嵌入水印图像')
subplot(1,2,2);
imshow(cover_boject,[])
title('原图像')

%%%%增加对比度攻击%%%%%
s=imread('lsb_watermarkedx.png');
J2=s;
xx1=imadjust(J2);
imwrite(xx1,'lsb_watermarkedc.png','png');

%计算PSNR
A=xx1;X=cover_boject;
[height width]=size(X);
X=double(X);
A=double(A);
sigma1=0;
for i=1:height
for j=1:width
sigma1=sigma1+(X(i,j)-A(i,j))^2;
end
end
mse=(sigma1/(height*width))   %均方误差
psnr=10*log10((255^2)/mse)

%水印提取
file_name='nd.png';
orig_watermark=imread(file_name);
for i=1:256
   for j=1:256
      mm(i,j)=bitget(uint8(xx1(i,j)),1);
      if double(mm(i,j))==1
         mm(i,j)=255;
      else
         mm(i,j)=0;
      end
   end
end
err=sum(sum(xor(m,mm)))/(256*256);

%显示运行时间
elapsed_time=cputime-start_time,

figure(3)
subplot(1,2,1);
imshow(uint8(mm));
title('提取水印图像');
subplot(1,2,2);
imshow(orig_watermark,[])
title('原始水印')
figure(4)
subplot(1,2,1);
imshow(xx1,[])
title('增加对比后水印')
subplot(1,2,2);
imshow(cover_boject,[])
title('原图像')