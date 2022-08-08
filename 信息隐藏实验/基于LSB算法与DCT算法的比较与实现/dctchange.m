clear;
clc;

disp('请选择载体图像：');
[filename2, pathname2] = uigetfile('*.jpg', '读取图片文件');
pathfile2=fullfile(pathname2, filename2);
image=imread(pathfile2); 
disp('请选择水印图像：');
[filename, pathname] = uigetfile('*.jpg', '读取图片文件');
pathfile=fullfile(pathname, filename);
markbefore=imread(pathfile); 

markbefore2=rgb2gray(markbefore);
mark=im2bw(markbefore2);    %使水印图像变为二值图
figure(1);      %打开窗口
subplot(2,3,1);    %该窗口内的图像可以有两行三列
imshow(mark),title('水印图像');   %显示水印图像
marksize=size(mark);   %计算水印图像的长宽
rm=marksize(1);      %rm为水印图像的行数
cm=marksize(2);     %cm为水印图像的列数

I=mark;
alpha=30;     %尺度因子,控制水印添加的强度,决定了频域系数被修改的幅度
k1=randn(1,8);  %产生两个不同的随机序列
k2=randn(1,8);
subplot(2,3,2),imshow(image,[]),title('载体图像'); %[]表示显示时灰度范围为image上的灰度最小值到最大值
yuv=rgb2ycbcr(image);   %将RGB模式的原图变成YUV模式
Y=yuv(:,:,1);    %分别获取三层，该层为灰度层
U=yuv(:,:,2);      %因为人对亮度的敏感度大于对色彩的敏感度，因此水印嵌在色彩层上
V=yuv(:,:,3);
[rm2,cm2]=size(U);   %新建一个和载体图像色彩层大小相同的矩阵
before=blkproc(U,[8 8],'dct2');   %将载体图像的灰度层分为8×8的小块，每一块内做二维DCT变换，结果记入矩阵before

after=before;   %初始化载入水印的结果矩阵
for i=1:rm          %在中频段嵌入水印
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