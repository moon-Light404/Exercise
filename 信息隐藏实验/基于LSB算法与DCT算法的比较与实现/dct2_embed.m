%Project: 	Threshold-Based Correlation in DCT mid-band
%           Uses two PN sequences; one for a "0" and another for a "1"
%水印嵌入

clear all;

% 保存开始时间 
start_time=cputime;

k=30;                           % 设置嵌入强度
blocksize=8;                    % 设置块的大小

midband=[   0,0,0,1,1,1,1,0;    % defines the mid-band frequencies of an 8x8 dct
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0 ];
        
% 读入原始图像
file_name='cam.png';
cover_object=double(imread(file_name));

% 原始图像的行数与列数
Mc=size(cover_object,1);	        %原图的行数
Nc=size(cover_object,2);	        %原图的列数

% 确定可嵌入的最大信息量
max_message=Mc*Nc/(blocksize^2);

% 读入水印图像
file_name='nd.png';
message=double(imread(file_name));
%水印图像的行数与列数
Mm=size(message,1)	                %水印图像的行数
Nm=size(message,2)	                %水印图像的列数

figure(1)
imshow(message,[]);
title('水印');

% 将水印图像矩阵转换为0，1组成的向量
message=reshape(message,1,Mm*Nm);

% 检查水印信息是否过大
if (length(message) > max_message)
   error('水印太大')
end

% 将message_vector置为全1向量，并将message写入
message_vector=ones(1,max_message);
message_vector(1:length(message))=message;

% 将cover_object写入watermarked image
watermarked_image=cover_object;

key=1100;
% 重置随机数发生器状态为key
rand('state',key),

% 生成伪随机数
pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));  

% 图象分块并嵌入
x=1;
y=1;
for (kk = 1:length(message_vector))
    % 分块进行DCT变换
    dct_block=dct2(cover_object(y:y+blocksize-1,x:x+blocksize-1));
    
    % 如果message_vector==0 并且midband==1，那么嵌入 pn_sequence_zero
    ll=1;
    if (message_vector(kk)==0)
        for ii=1:blocksize
            for jj=1:blocksize
                if (midband(jj,ii)==1)
                    dct_block(jj,ii)=dct_block(jj,ii)+k*pn_sequence_zero(ll);
                    ll=ll+1;
                end
            end
        end
    end
    
    % 逆DCT变换
    watermarked_image(y:y+blocksize-1,x:x+blocksize-1)=idct2(dct_block);    
    
    % 移动到下一块
    if (x+blocksize) >= Nc
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
end

% 转换为uint8 并将watermarked_image_uint8写入watermarked_image_uint8.bmp
watermarked_image_uint8=uint8(watermarked_image);
imwrite(watermarked_image_uint8,'watermarked_image_uint8.bmp','bmp');

% 显示运行时间
elapsed_time=cputime-start_time,

% 计算psnr
A=watermarked_image_uint8;X=cover_object;
[height width]=size(X);
X=double(X);
A=double(A);
sigma1=0;
for i=1:height
for j=1:width
sigma1=sigma1+(X(i,j)-A(i,j))^2;
end
end
mse=(sigma1/(height*width));   %均方误差
psnr=10*log10((255^2)/mse)

% 显示嵌入水印图象与原始图象
figure(2)
subplot(1,2,1);
imshow(watermarked_image_uint8,[])
title('嵌入水印图像')
subplot(1,2,2)
imshow(cover_object,[]);
title('原始图像');
