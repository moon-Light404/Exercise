package cn.edu.ldu;
import cn.edu.ldu.util.Message;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.List;
import javax.swing.SwingWorker;

/**
 * FileSender类，发送文件的后台线程类
 * @author 董相志，版权所有2016--2018，upsunny2008@163.com
 */
public class FileSender extends SwingWorker<List<String>,String>{
    private File file; //文件
    private Message msg;//消息类
    private ClientUI parentUI; //父类
    private Socket fileSocket; //传送文件的套接字
    private static final int BUFSIZE=8096; //缓冲区大小
    private int progress=0; //文件传送进度
    private String lastResults=null; //传送结果
    //构造函数
    public FileSender(File file,Message msg,ClientUI parentUI) {
        this.file=file;
        this.msg=msg;
        this.parentUI=parentUI;
    }
    @Override
    protected List<String> doInBackground() throws Exception {  
        fileSocket=new Socket();
        //连接服务器
        SocketAddress remoteAddr=new InetSocketAddress(msg.getToAddr(),msg.getToPort());
        fileSocket.connect(remoteAddr); 
        //构建套接字输出流
        DataOutputStream out=new DataOutputStream(
                             new BufferedOutputStream(
                             fileSocket.getOutputStream()));
        //构建文件输入流
        DataInputStream in=new DataInputStream(
                           new BufferedInputStream(
                           new FileInputStream(file)));
        long fileLen=file.length();  //计算文件长度
        //发送文件名称、文件长度
        out.writeUTF(file.getName());
        out.writeLong(fileLen);
        out.flush();
        //传送文件内容
        int numRead=0; //单次读取的字节数
        int numFinished=0; //总完成字节数
        byte[] buffer=new byte[BUFSIZE];   
        while (numFinished<fileLen && (numRead=in.read(buffer))!=-1) { //文件可读  
            out.write(buffer,0,numRead);  //发送
            out.flush();
            numFinished+=numRead; //已完成字节数
            Thread.sleep(200); //演示文件传输进度用
            publish(numFinished+"/"+fileLen+"bytes");
            setProgress(numFinished*100/(int)fileLen);             
        }//end while
        in.close(); 
        //接收服务器反馈信息
        BufferedReader br=new BufferedReader(
                          new InputStreamReader(
                          fileSocket.getInputStream()));
        String response=br.readLine();//读取返回串        
        if (response.equalsIgnoreCase("M_DONE")) { //服务器成功接收               
            lastResults=  file.getName() +"  传送成功！\n" ;
        }else if (response.equalsIgnoreCase("M_LOST")){ //服务器接收失败
            lastResults=  file.getName() +"  传送失败！\n" ;
        }//end if
        //关闭流
        br.close();
        out.close();
        fileSocket.close();
        return null;
    } //doInBackground 
    @Override
    protected void process(List<String> middleResults) {
        for (String str:middleResults) {
            parentUI.progressLabel.setText(str);
        }   
    }
    // doInBackground函数执行完毕
    @Override
    protected void done() {
        parentUI.progressBar.setValue(parentUI.progressBar.getMaximum());
        parentUI.txtArea.append(lastResults+"\n");
        parentUI.filePanel.setVisible(false);
    }
}