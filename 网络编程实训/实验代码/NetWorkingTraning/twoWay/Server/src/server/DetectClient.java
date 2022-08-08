/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.Scanner;

/**
 *
 * @author jun Ding
 */
public class DetectClient {

    /**
     * @param args the command line arguments
     */
    private receiveClinet res = null;
    private BackInfo back = null;
    
    public receiveClinet getClinet(BufferedReader br) {
        if(res == null) res = new receiveClinet(br);
        return res;
    }
    
    public BackInfo getBackInfo(BufferedWriter bw) {
        if(back == null)    back = new BackInfo(bw);
        return back;
    }
    class receiveClinet extends Thread {
        BufferedReader br = null;

        public receiveClinet(BufferedReader br) {
            this.br = br;
        }

        @Override
        public void run() {
            while(true) {
                try {
                String temp = br.readLine();
//                System.out.println("客户端 : " + temp);
                ServerUI.txtArea.setText("客户端 : " + temp);
            }catch (IOException e) {
                System.out.println("从客户端读取数据发现连接断开");
                System.exit(1);
            }
           }
        }
    }
    
    class BackInfo extends Thread {
        BufferedWriter bw = null;
        Scanner scan = new Scanner(System.in);
        BackInfo(BufferedWriter bw) {
            this.bw = bw;
        }

        @Override
        public void run() {
            while (true) {
                String str = scan.nextLine();
                try {
//                  System.out.println("服务端消息 ：" + str);
                    ServerUI.txtArea.setText("服务端消息 : " +str);
                    bw.write(str + "\n"); // 向客户端写入诗句
                    bw.flush();
                }catch (IOException e) {
                    System.out.println("出现异常");
                    System.exit(1);
                }
            }
        }
    }
}
