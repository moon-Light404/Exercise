/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.awt.Dimension;
import java.awt.Event;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.font.GraphicAttribute;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.SwingConstants;


/**
 * 接收截图线程
 * @author jun Ding
 */
public class receivePicThread extends Thread{
    private DataInputStream dis = null;
    private showUI showUI = null;
    public receivePicThread(DataInputStream dis,showUI showI) {
        this.dis = dis;
        this.showUI = showI;
    }


    @Override
    public void run() {
        byte[] imageBytes;
        try {
            while(true) {
                if(dis.readChar() == 'A') { // 图片信息
                    imageBytes = new byte[dis.readInt()];
                    dis.readFully(imageBytes); // 所以数据放到byte中
                    showUI.repaintImage(imageBytes);
                }
            }
        } catch (IOException ex) {
//            Logger.getLogger(receivePicThread.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
