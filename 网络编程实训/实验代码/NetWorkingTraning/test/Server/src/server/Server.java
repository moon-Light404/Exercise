package server;
import utils.Message;
import utils.MessageType;

import java.awt.*;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Vector;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * @author DingJun
 * @date 2021/9/16 23:36
 */
public class Server {
    public static void main(String[] args) {
        //保存客户端处理的线程
        Vector<UserThread> vector = new Vector<>();
        //固定大小的线程池，用来处理不同客户端
        ExecutorService es = Executors.newFixedThreadPool(5);
        //创建服务器端的Socket
        try {
            ServerSocket server = new ServerSocket(8888);
            System.out.println("服务器以启动，正在等待连接...");
            while (true) {
                //接受客户端的Socket，若没有，阻塞在这
                Socket socket = server.accept();
                //每来一个客户端，创建一个线程处理它
                UserThread user = new UserThread(socket, vector);
                es.execute(user);  //开启线程
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}


/**
 * 客户端处理线程：
 */
class UserThread implements Runnable{
    private String name; //客户端的用户名称，唯一
    private Socket socket;
    private Vector<UserThread> vector;   //客户端处理线程的集合
    private ObjectInputStream oIn;    //输入流
    private ObjectOutputStream oOut;  //输出流
    private boolean flag = true;  //标记

    public UserThread(Socket socket, Vector<UserThread> vector) {
        this.socket = socket;
        this.vector = vector;
        vector.add(this);    //把当前线程也加入vector中
    }

    @Override
    public void run() {
        try {
            //1、构造输入输出流
            System.out.println("客户端：" + socket.getInetAddress().getHostAddress() + "已连接！");
            oIn = new ObjectInputStream(socket.getInputStream());
            oOut = new ObjectOutputStream((socket.getOutputStream()));
            //2、循环读取
            while(flag){
                //读取消息对象
                Message message = (Message)oIn.readObject();
                //获取消息类型，登录还是发送消息
                int type = message.getType();
                //3、判断
                switch (type){
                    //如果是发送消息
                    case MessageType.TYPE_SEND:
                        String to = message.getTo();//发送给谁
                        UserThread ut;
                        //遍历vector，找到接收信息的客户端
                        int size = vector.size();
                        for (int i = 0; i < size; i++) {
                            ut = vector.get(i);
                            //如果名字相同，且不是自己，就把信息发给它
                            if(to.equals(ut.name) && ut != this){
                                ut.oOut.writeObject(message); //发送消息对象
                            }
                        }
                        break;
                    //如果是登录
                    case MessageType.TYPE_LOGIN:
                        name = message.getFrom();//获取用户名
                        message.setInfo("欢迎您！");//设置登录成功信息
                        oOut.writeObject(message);
                        break;
                }

            }



        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }

    }
}

