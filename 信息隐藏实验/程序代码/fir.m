clear;
img_hidden=imread('dingjun.jpg');
img_hidden=rgb2gray(img_hidden);
imwrite(img_hidden,'dingjun.bmp');
    
img=imread('source.jpg');
img=rgb2gray(img);% 将RGB图像转化为灰度图
imwrite(img,'source.bmp');% 将灰度图保存

img_f=img;
 
[row_h,col_h]=size(img_hidden);
[row,col]=size(img);
 

%对图像分块，计算每一块的熵值
for i=1:row_h/8
   for j=1:col_h/8
       block=img((i-1)*8+1:i*8,(j-1)*8+1:j*8,:);
       block_h=img_hidden((i-1)*8+1:i*8,(j-1)*8+1:j*8,:);
       e(i,j)=entropy(block);
       e_h(i,j)=entropy(block_h);
   end
end

%对熵值矩阵进行降维，然后降序排序
e=e(:);
e_h=e_h(:);
[e,I]=sort(e,'descend');
[e_h,I_h]=sort(e_h,'descend');
 
%利用图像降级的方法，将水印图像中熵值高的图像块隐藏在原图像熵值高的图像块中
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
%保存图像块替换的顺序
save('I.mat','I');
save('I_h.mat','I_h');
 
figure;
subplot(1,3,1);imshow('source.bmp');title('原始图像');
subplot(1,3,2);imshow('dingjun.bmp');title('水印图像');
subplot(1,3,3);imshow('result.bmp');title('嵌入水印图像');