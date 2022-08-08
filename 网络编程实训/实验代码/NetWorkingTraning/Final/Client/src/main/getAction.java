/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.awt.AWTException;
import java.awt.Event;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.net.Socket;
import java.util.Calendar;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/** 客户端接收控制端操作消息
 *
 * @author jun Ding
 */
public class getAction implements Runnable,Serializable{
    private ObjectInputStream OIS = null;
    private Robot robot = null;
    
    public getAction(Socket ss) {
        System.out.println("启动");
        try {
            this.OIS = new ObjectInputStream(ss.getInputStream());
        } catch (IOException ex) {
            System.out.println("出现错误");
        }
    }
    
    @Override
    public void run() {
        try {
            robot = new Robot();
            int i = 1,j = 1, k = 1;
            while(true) {
                Object o = null;
                o = OIS.readObject();
                if (o instanceof MouseWheelEvent) {
                    mouseWheelEvent((MouseWheelEvent) o); //处理鼠标滚轮事件
                    ClientUI.txtInfo.append((i++) +"收到了鼠标滚轮\n");
                } else if (o instanceof KeyInfo) {
                    keyEvent((KeyInfo) o); // 处理键盘事件
                    ClientUI.txtInfo.append((j++) + "收到了键盘信息\n" );
                } else if (o instanceof MouseEvent) {
                    mouseEvent((MouseEvent) o);//处理鼠标事件
                    ClientUI.txtInfo.append( (k++) +"收到了鼠标事件\n");
                }else {
                    FileSendEvent(o);
                }
        } 
        }catch (IOException ex) {
           ClientUI.btnCon.setEnabled(true);
        } catch (ClassNotFoundException ex) {
//            Logger.getLogger(getAction.class.getName()).log(Level.SEVERE, null, ex);
        } catch (AWTException ex) {
//            Logger.getLogger(getAction.class.getName()).log(Level.SEVERE, null, ex);
        }
    }    
    
    public void FileSendEvent(Object o) {
        Map o1 = (Map) o;
        receiveFile receFile = new receiveFile(o1, "D:\\receFile");
        ClientUI.txtInfo.append("接收文件，开始文件传输\n");
        Thread receThread = new Thread(receFile);
        receThread.start();
    }
    /**
     * 滚轮事件
     * @param e 
     */
    public void mouseWheelEvent(MouseWheelEvent e) {
        if (e.getPreciseWheelRotation() > 0) {//鼠标向上滑动
            robot.mouseWheel(1);
        } else {//鼠标向下滑动
            robot.mouseWheel(-1);
        }
    }
    
    /**
     * 鼠标事件
     */
    public void mouseEvent(MouseEvent e) {
        int type = e.getID();
        if (type == Event.MOUSE_MOVE) {//鼠标移动草走
            robot.mouseMove(e.getX(), e.getY());
        } else if (type == Event.MOUSE_DOWN) {//鼠标按下操作
            type = getMouseKey(e.getButton());
            robot.mousePress(type);
        } else if (type == Event.MOUSE_UP) {//鼠标按上来操作
            robot.mouseRelease(getMouseKey(e.getButton()));
        } else if (type == Event.MOUSE_DRAG) {//鼠标按住移动操作
            int x = e.getX();
            int y = e.getY();
            robot.mouseMove(x, y);//鼠标拖动
        }
    }
    
    /**
     * 键盘事件
     */
    public void keyEvent(KeyInfo info) {
        int type = info.getEvent();//拿到事件类型
        if (type == Event.KEY_PRESS) {
            robot.keyPress(info.getKey_code());
        } else if (type == Event.KEY_RELEASE) {
            robot.keyRelease(info.getKey_code());
        }
    }
    
     /**
     * 返回鼠标的真正事件，鼠标时间不能直接处理，需要进过转换
     *
     */
    public int getMouseKey(int button) {
        if (button == MouseEvent.BUTTON1) {//鼠标左键
            return InputEvent.BUTTON1_MASK;
        } else if (button == MouseEvent.BUTTON2) {//鼠标右键
            return InputEvent.BUTTON2_MASK;
        } else if (button == MouseEvent.BUTTON3) {//滚轮
            return InputEvent.BUTTON3_MASK;
        } else {
            return 0;
        }
    }
}
