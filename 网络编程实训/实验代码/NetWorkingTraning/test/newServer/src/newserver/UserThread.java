/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newserver;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Vector;
import utils.Message;
import utils.MessageType;

/**
 *处理客户端线程
 * @author jun Ding
 */
public class UserThread implements Runnable{

    private String name; // 客户端名称
    private Socket socket;
    private Vector<UserThread> vector; // 客户端处理线程的集合
    private ObjectInputStream oIn; // 输入流
    private ObjectOutputStream oOut;// 输出流
    
    public UserThread(Socket socket,Vector<UserThread> vector) {
        this.socket = socket;
        this.vector = vector;
        vector.add(this);
    }
    // 客户机线程已连接服务器.... 开始处理
    @Override
    public void run() {
        try {
            // 构建输入输出流
            oIn = new ObjectInputStream(socket.getInputStream());
            oOut = new ObjectOutputStream(socket.getOutputStream());
            // 循环读取
            while(true) {
                // 读取消息对象
                Message message = (Message)oIn.readObject();
                // 获取信息类型，是登录还是发送消息
                int type = message.getType();
                // 判断
                switch(type) {
                    case MessageType.TYPE_SEND:
                        String to = message.getTo(); // 发送给谁
                        UserThread ut;
                        int size = vector.size();
                        for(int i = 0;i < size;i++) {
                            ut = vector.get(i);
                            if(to.equals(ut.name) && ut != this) {
                                ut.oOut.writeObject(message);
                                ServerUI.txtArea.append("->"+message.getFrom()+"对"+message.getTo()+"说"+message.getInfo()+"\n");
                            }
                        }
                        break;
                    case MessageType.TYPE_LOGIN:
                        name = message.getFrom(); // 处理客户端线程名字
                        ServerUI.txtArea.append("客户端" + name + "已连接......\n");
                        message.setInfo("欢迎您!");
                        oOut.writeObject(message);
                        break;
                }
            }
        } catch (Exception e) {
        }
 
       
    }
    
}
