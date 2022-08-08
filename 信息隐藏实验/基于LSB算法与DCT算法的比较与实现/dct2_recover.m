%������lufei��ˮӡ���루����ˮӡ��̳��
%����wyy022
%Project: 	Threshold-Based Correlation in DCT mid-band
%           Uses two PN sequences; one for a "0" and another for a "1"
%           ˮӡ��ȡ

clear all;

% ���濪ʼʱ��
start_time=cputime;

blocksize=8;                    % ���ÿ�Ĵ�С
midband=[   0,0,0,1,1,1,1,0;    % defines the mid-band frequencies of an 8x8 dct
            0,0,1,1,1,1,0,0;
            0,1,1,1,1,0,0,0;
            1,1,1,1,0,0,0,0;
            1,1,1,0,0,0,0,0;
            1,1,0,0,0,0,0,0;
            1,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0 ];
            
% ����Ƕ��ˮӡͼ��
file_name='watermarked_image_uint8.bmp';
watermarked_image=double(imread(file_name));

% Ƕ��ˮӡͼ�������������
Mw=size(watermarked_image,1);	        %����
Nw=size(watermarked_image,2);	        %���� 

% ȷ�����Ƕ����Ϣ��
max_message=Mw*Nw/(blocksize^2);

% ����ˮӡ
file_name='nd.png';
orig_watermark=double(imread(file_name));

% ˮӡ������������
Mo=size(orig_watermark,1);	%����
No=size(orig_watermark,2);	%����


key=1100;

% ���������������״̬Ϊkey
rand('state',key);

% ����α�������
pn_sequence_zero=round(2*(rand(1,sum(sum(midband)))-0.5));

% process the image in blocks
x=1;
y=1;
for (kk = 1:max_message)

    % �Կ����DCT�任
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
    
    % ���������ϵ��
    correlation(kk)=corr2(pn_sequence_zero,sequence);

    % �ƶ�����һ��
    if (x+blocksize) >= Nw
        x=1;
        y=y+blocksize;
    else
        x=x+blocksize;
    end
end

% ��������ϵ������ƽ��ֵ��ô�� '0', ��֮�� '1'
for (kk=1:max_message)
    if (correlation(kk) >mean(correlation(1:max_message)))
        message_vector(kk)=0;
    else
        message_vector(kk)=1;
    end
end

% ����������ȡˮӡ

message=reshape(message_vector(1:Mo*No),Mo,No);

% ��ʾ����ʱ��
elapsed_time=cputime-start_time,

% ��ʾ��ȡˮӡ��ԭʼˮӡ

figure(3)
imshow(message,[])
title('��ȡˮӡ')
figure(4)
imshow(orig_watermark,[])
title('ԭʼˮӡ');
