%整理自lufei的水印代码（数字水印论坛）
%整理：wyy022
%Project: 	Threshold-Based Correlation in DCT mid-band
%           Uses two PN sequences; one for a "0" and another for a "1"
%           水印提取

clear all;

% 保存开始时间
start_time=cputime;

blocksize=8;                    % 设置块的大小
midband=[   0,0,0,1,1,1,1,0;    % defines the mid-band frequencies of an 8x8 dct
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0 ];
            
% 读入嵌入水印图像
file_name='watermarked_image_uint8.bmp';
watermarked_image=double(imread(file_name));

% 嵌入水印图像的行数与烈数
Mw=size(watermarked_image,1);	        %行数
Nw=size(watermarked_image,2);	        %列数 

% 确定最大嵌入信息量
max_message=Mw*Nw/(blocksize^2);

% 读入水印
file_name='nd.png';
orig_watermark=double(imread(file_name));

% 水印的行数与列数
Mo=size(orig_watermark,1);	%行数
No=size(orig_watermark,2);	%列数


key=1100;

% 置随机数发生器的状态为key
rand('state',key);

% 产生伪随机序列
pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));

% process the image in blocks
x=1;
y=1;
for (kk = 1:max_message)

    % 对块进行DCT变换
    dct_block=dct2(watermarked_image(y:y+blocksize-1,x:x+blocksize-1));
    
    % extract the middle band coeffcients
    ll=1;
    for ii=1:blocksize
        for jj=1:blocksize
            if (midband(jj,ii)==1)
                sequence(ll)=dct_block(jj,ii);
                ll=ll+1;
            end
        end
    end
    
    % 计算相关性系数
    correlation(kk)=corr2(pn_sequence_zero,sequence);

    % 移动到下一块
    if (x+blocksize) >= Nw
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
end

% 如果相关性系数大于平均值那么置 '0', 反之置 '1'
for (kk=1:max_message)
    if (correlation(kk) >mean(correlation(1:max_message)))
        message_vector(kk)=0;
    else
        message_vector(kk)=1;
    end
end

% 重新排列提取水印

message=reshape(message_vector(1:Mo*No),Mo,No);

% 显示运行时间
elapsed_time=cputime-start_time,

% 显示提取水印与原始水印

figure(3)
imshow(message,[])
title('提取水印')
figure(4)
imshow(orig_watermark,[])
title('原始水印');
