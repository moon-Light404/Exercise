/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/**接收消息线程
 *
 * @author jun Ding
 */
public class receiveClient extends Thread{
    private Socket clientSocket = null;
    private BufferedReader br = null;
    
    public receiveClient(Socket ss) {
        this.clientSocket = ss;
        try {
            this.br = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void run() {
         while(true) {
           try {
                String temp = br.readLine();
                if(temp != null) {
                    ServerUI.txtArea.append("来自客户端的消息 ：" + temp + "\n");
                }
            }catch(IOException e) {
                e.printStackTrace();
            }
            }
    }
    
    
}
