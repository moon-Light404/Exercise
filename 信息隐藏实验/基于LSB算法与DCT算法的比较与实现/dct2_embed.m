%Project: 	Threshold-Based Correlation in DCT mid-band
%           Uses two PN sequences; one for a "0" and another for a "1"
%ˮӡǶ��

clear all;

% ���濪ʼʱ�� 
start_time=cputime;

k=30;                           % ����Ƕ��ǿ��
blocksize=8;                    % ���ÿ�Ĵ�С

midband=[   0,0,0,1,1,1,1,0;    % defines the mid-band frequencies of an 8x8 dct
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0 ];
        
% ����ԭʼͼ��
file_name='cam.png';
cover_object=double(imread(file_name));

% ԭʼͼ�������������
Mc=size(cover_object,1);	        %ԭͼ������
Nc=size(cover_object,2);	        %ԭͼ������

% ȷ����Ƕ��������Ϣ��
max_message=Mc*Nc/(blocksize^2);

% ����ˮӡͼ��
file_name='nd.png';
message=double(imread(file_name));
%ˮӡͼ�������������
Mm=size(message,1)	                %ˮӡͼ�������
Nm=size(message,2)	                %ˮӡͼ�������

figure(1)
imshow(message,[]);
title('ˮӡ');

% ��ˮӡͼ�����ת��Ϊ0��1��ɵ�����
message=reshape(message,1,Mm*Nm);

% ���ˮӡ��Ϣ�Ƿ����
if (length(message) > max_message)
   error('ˮӡ̫��')
end

% ��message_vector��Ϊȫ1����������messageд��
message_vector=ones(1,max_message);
message_vector(1:length(message))=message;

% ��cover_objectд��watermarked image
watermarked_image=cover_object;

key=1100;
% ���������������״̬Ϊkey
rand('state',key),

% ����α�����
pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));  

% ͼ��ֿ鲢Ƕ��
x=1;
y=1;
for (kk = 1:length(message_vector))
    % �ֿ����DCT�任
    dct_block=dct2(cover_object(y:y+blocksize-1,x:x+blocksize-1));
    
    % ���message_vector==0 ����midband==1����ôǶ�� pn_sequence_zero
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
    
    % ��DCT�任
    watermarked_image(y:y+blocksize-1,x:x+blocksize-1)=idct2(dct_block);    
    
    % �ƶ�����һ��
    if (x+blocksize) >= Nc
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
end

% ת��Ϊuint8 ����watermarked_image_uint8д��watermarked_image_uint8.bmp
watermarked_image_uint8=uint8(watermarked_image);
imwrite(watermarked_image_uint8,'watermarked_image_uint8.bmp','bmp');

% ��ʾ����ʱ��
elapsed_time=cputime-start_time,

% ����psnr
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
mse=(sigma1/(height*width));   %�������
psnr=10*log10((255^2)/mse)

% ��ʾǶ��ˮӡͼ����ԭʼͼ��
figure(2)
subplot(1,2,1);
imshow(watermarked_image_uint8,[])
title('Ƕ��ˮӡͼ��')
subplot(1,2,2)
imshow(cover_object,[]);
title('ԭʼͼ��');
