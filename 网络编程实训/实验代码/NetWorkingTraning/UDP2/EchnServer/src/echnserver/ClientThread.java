/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package echnserver;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javafx.scene.chart.PieChart;

/**
 *
 * @author jun Ding
 */
public class ClientThread extends Thread{
    private Socket toClientSocket = null;
    private BufferedReader in;
    private PrintWriter out;
    private int clientCounts = 0;
    public ClientThread(Socket toClientSocket,int clientCounts) {
        this.toClientSocket = toClientSocket;
        this.clientCounts = clientCounts;
    }

    @Override
    public void run() {
        try {
            in = new BufferedReader(new InputStreamReader(toClientSocket.getInputStream(),"UTF-8"));
            out = new PrintWriter(new OutputStreamWriter(toClientSocket.getOutputStream(),"UTF-8"),true);
            String recvStr;
            while((recvStr=in.readLine()) !=null) {
                Date date = new Date();
                DateFormat format = new SimpleDateFormat("yyy-mm-dd hh:mm:ss");
                String time = format.format(date);
                ServerUI.txtArea.append(toClientSocket.getRemoteSocketAddress()+"客户机编号"+clientCounts+
                        "消息："+recvStr+" : "+time+"\n");
                out.print(toClientSocket.getLocalSocketAddress()+" 客户机编号: "+clientCounts+" Echo消息: "+recvStr+" : "+time+"\n");
                // 这里之前有一个错误,写成了out.println然后后面也有一个回车，那么客户端在读取数据的时候，readLine会出现间隔读取
                // 服务端发送的数据
                out.flush();
            }
            ServerUI.clientCounts--;
            if(in!=null)    in.close();
            if(out!=null)  out.close();
            if(toClientSocket!=null) toClientSocket.close();
        }catch(IOException ex) {
            
        }
    }
    
    
}
