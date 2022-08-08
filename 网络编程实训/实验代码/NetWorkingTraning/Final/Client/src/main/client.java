/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.awt.event.KeyEvent;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author jun Ding
 */
public class client {
    private static DataOutputStream dos = null;
//    private static ObjectInputStream OIS = null;
    private static Socket socket = null;
    
    public client(Socket ss) {
        this.socket = ss;
    }
    
     public void Task() {
        int time = 0;
        try {
            ExecutorService es = Executors.newSingleThreadExecutor();
            dos = new DataOutputStream(socket.getOutputStream());
            time = Integer.parseInt(ClientUI.speed.getText()); // 调节帧率
            ImageThread imageThread = new ImageThread(dos, time);
            es.execute(imageThread); // 启动图片发送线程
            // 接收控制键盘和鼠标信息
            new Thread(new getAction(socket)).start();
        } catch (IOException ex) {
//            Logger.getLogger(client.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
