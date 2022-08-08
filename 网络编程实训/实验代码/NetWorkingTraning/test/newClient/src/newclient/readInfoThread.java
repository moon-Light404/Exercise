/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package newclient;

import java.io.ObjectInputStream;
import utils.Message;

/**
 *
 * @author jun Ding
 */
public class readInfoThread implements Runnable{
    private ObjectInputStream oIn;
    public readInfoThread(ObjectInputStream oIn) {
        this.oIn = oIn;
    } 
    
    @Override
    public void run() {
        try {
            while(true) {
                // 读取信息
                Message message = (Message)oIn.readObject();
                ClientUI.txtArea.append("[" + message.getFrom() + "]对我说" + message.getInfo()+"\n");
            }
        } catch (Exception e) {
            
        }
    }
    
}
