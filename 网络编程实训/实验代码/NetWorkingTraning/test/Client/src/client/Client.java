/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package client;

import java.util.Scanner;
import utils.Message;
import utils.MessageType;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
/**
 *
 * @author jun Ding
 */
public class Client {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        //单线程池
        ExecutorService es = Executors.newSingleThreadExecutor();
        try {
            //创建客户端
            Socket socket = new Socket("localhost", 8888);
            System.out.println("服务器连接成功！");
            //构建输出输入流
            ObjectOutputStream oOut = new ObjectOutputStream(socket.getOutputStream());
            ObjectInputStream oIn = new ObjectInputStream(socket.getInputStream());
            //1、客户端登录处理
            //向服务器发送登录信息（名字和消息类型）
            System.out.println("请输入名称：");
            String name = input.nextLine();
            //登录时，只自己的名字和消息类型为登录
            Message message = new Message(name, null, MessageType.TYPE_LOGIN, null);
            //发送给服务器
            oOut.writeObject(message);
            //服务器返回 欢迎信息
            message = (Message) oIn.readObject();
            //打印服务器返回的信息+当前客户端的名字
            System.out.println(message.getInfo() + message.getFrom());
            //2、启动读取消息的线程
            es.execute(new readInfoThread(oIn));  //读取线程完成

            //3、发送消息
            //使用主线程来发送消息
            boolean flag = true;
            //循环
            while(flag){
                //创建对象
                message = new Message();
                //发给谁
                System.out.println("To：");
                message.setTo(input.nextLine());
                //谁发的，从自己这发
                message.setFrom(name);
                //类型 发送消息
                message.setType(MessageType.TYPE_SEND);
                //发送的内容
                System.out.println("Info：");
                message.setInfo(input.nextLine());
                /*----到此需要发送的消息 对象 封装完毕----*/
                //发送给服务器
                oOut.writeObject(message);
            }

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
}


/**
 * 读取其他客户端发来消息
 */
class readInfoThread implements Runnable {
    private ObjectInputStream oIn; //输入流 用来读操作
    private boolean flag = true; //标记

    public readInfoThread(ObjectInputStream oIn) {
        this.oIn = oIn;
    }

    public void setFlag(boolean flag) {
        this.flag = flag;
    }

    @Override
    public void run() {

        try {
            //循环 不断读取消息
            while (flag) {
                //读取信息
                Message message = (Message) oIn.readObject();
                //输出用户名+内容
                System.out.println("[" + message.getFrom() + "]对我说：" + message.getInfo());
            }
            //没有数据就关闭
            if(oIn != null){
                oIn.close();
            }

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }


    }
}