clear;
clc;

disp('��ѡ������ͼ��');
[filename2, pathname2] = uigetfile('*.jpg', '��ȡͼƬ�ļ�');
pathfile2=fullfile(pathname2, filename2);
image=imread(pathfile2); 
disp('��ѡ��ˮӡͼ��');
[filename, pathname] = uigetfile('*.jpg', '��ȡͼƬ�ļ�');
pathfile=fullfile(pathname, filename);
markbefore=imread(pathfile); 

markbefore2=rgb2gray(markbefore);
mark=im2bw(markbefore2);    %ʹˮӡͼ���Ϊ��ֵͼ
figure(1);      %�򿪴���
subplot(2,3,1);    %�ô����ڵ�ͼ���������������
imshow(mark),title('ˮӡͼ��');   %��ʾˮӡͼ��
marksize=size(mark);   %����ˮӡͼ��ĳ���
rm=marksize(1);      %rmΪˮӡͼ�������
cm=marksize(2);     %cmΪˮӡͼ�������

I=mark;
alpha=30;     %�߶�����,����ˮӡ��ӵ�ǿ��,������Ƶ��ϵ�����޸ĵķ���
k1=randn(1,8);  %����������ͬ���������
k2=randn(1,8);
subplot(2,3,2),imshow(image,[]),title('����ͼ��'); %[]��ʾ��ʾʱ�Ҷȷ�ΧΪimage�ϵĻҶ���Сֵ�����ֵ
yuv=rgb2ycbcr(image);   %��RGBģʽ��ԭͼ���YUVģʽ
Y=yuv(:,:,1);    %�ֱ��ȡ���㣬�ò�Ϊ�ҶȲ�
U=yuv(:,:,2);      %��Ϊ�˶����ȵ����жȴ��ڶ�ɫ�ʵ����жȣ����ˮӡǶ��ɫ�ʲ���
V=yuv(:,:,3);
[rm2,cm2]=size(U);   %�½�һ��������ͼ��ɫ�ʲ��С��ͬ�ľ���
before=blkproc(U,[8 8],'dct2');   %������ͼ��ĻҶȲ��Ϊ8��8��С�飬ÿһ��������άDCT�任������������before

after=before;   %��ʼ������ˮӡ�Ľ������
for i=1:rm          %����Ƶ��Ƕ��ˮӡ
    for j=1:cm
        x=(i-1)*8;
        y=(j-1)*8;
        if mark(i,j)==1
            k=k1;
        else
            k=k2;
        end
        after(x+1,y+8)=before(x+1,y+8)+alpha*k(1);
        after(x+2,y+7)=before(x+2,y+7)+alpha*k(2);
        after(x+3,y+6)=before(x+3,y+6)+alpha*k(3);
        after(x+4,y+5)=before(x+4,y+5)+alpha*k(4);
        after(x+5,y+4)=before(x+5,y+4)+alpha*k(5);
        after(x+6,y+3)=before(x+6,y+3)+alpha*k(6);
        after(x+7,y+2)=before(x+7,y+2)+alpha*k(7);
        after(x+8,y+1)=before(x+8,y+1)+alpha*k(8);
    end
end