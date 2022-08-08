clear;
%¶ÁÈ¡Í¼Ïñ
img=imread('result.bmp');
% img=rgb2gray(img);
[row,col]=size(img);
img_f=img;
 
%¶ÁÈ¡Í¼Ïñ¿éÌæ»»Ë³ÐòÊý¾Ý
I=load('I.mat','I');    
I=I.I;
I_h=load('I_h.mat','I_h');
I_h=I_h.I_h;
 
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
    block=img((r-1)*8+1:r*8,(c-1)*8+1:c*8,:);% È¡Í¼Ïñ¿é    [x,y]=size(block);
    img_t=block;
    [x,y]=size(block);
    for a=1:x
        for b=1:y
            tmp=dec2bin(block(a,b),8);
            tmp(1:4)=tmp(5:8);
            tmp(5:8)=['0','0','0','0'];
            img_t(a,b)=bin2dec(tmp);
        end
    end
    img_f((r_h-1)*8+1:r_h*8,(c_h-1)*8+1:c_h*8)=img_t;% Ìæ»»Í¼Ïñ¿é
end
 
imwrite(img_f,'extract.bmp')
 
figure;
subplot(1,3,1);imshow('result.bmp');title('Ç¶ÈëË®Ó¡Í¼Ïñ');
subplot(1,3,2);imshow('dingjun.bmp');title('Ë®Ó¡Í¼Ïñ');
subplot(1,3,3);imshow('extract.bmp');title('ÌáÈ¡Ë®Ó¡Í¼Ïñ');