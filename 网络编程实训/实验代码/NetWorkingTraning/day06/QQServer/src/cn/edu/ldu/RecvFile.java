package cn.edu.ldu;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.net.Socket;
import javax.swing.SwingWorker;

/**
 * RecvFile类，接收文件的后台线程类
 * 作者：董相志，版权所有2016--2018，upsunny2008@163.com
 */
public class RecvFile extends SwingWorker<Integer,Object> {
    private final Socket fileSocket; //接收文件的套接字
    private ServerUI parentUI; //主窗体类
    private static final int BUFSIZE=8096;//缓冲区大小    
    public RecvFile(Socket fileSocket,ServerUI parentUI) { 
        this.fileSocket=fileSocket;
        this.parentUI=parentUI;
    }
    @Override
    protected Integer doInBackground() throws Exception {        
        //获取套接字输入流
        DataInputStream in=new DataInputStream(
                           new BufferedInputStream(
                           fileSocket.getInputStream()));        
        //接收文件名、文件长度
        String filename=in.readUTF(); //文件名
        int fileLen=(int)in.readLong(); //文件长度       
        //创建文件输出流
        File file=new File("./upload/"+filename);       
        //文件输出流
        BufferedOutputStream out=new BufferedOutputStream(
                                  new FileOutputStream(file));        
        //接收文件内容，存储为外部文件
        byte[] buffer=new byte[BUFSIZE]; //读入缓冲区
        int numRead=0; //单次读取的字节数
        int numFinished=0;//总完成字节数
        while (numFinished<fileLen && (numRead=in.read(buffer))!=-1) { //输入流可读      
            out.write(buffer,0,numRead);
            numFinished+=numRead; //已完成字节数
        }//end while
        //定义字符输出流
        PrintWriter pw=new PrintWriter(fileSocket.getOutputStream(),true);
        if (numFinished>=fileLen) {//文件接收完成？
            pw.println("M_DONE"); //回送成功消息
            parentUI.txtArea.append(filename+"  接收成功！\n");
        }else {
            pw.println("M_LOST"); //回送失败消息
            parentUI.txtArea.append(filename+"  接收失败！\n");
        }//end if        
        //关闭流
        in.close();
        out.close();
        pw.close();
        fileSocket.close();
        return 100;
    }//end doInBackground    
}
