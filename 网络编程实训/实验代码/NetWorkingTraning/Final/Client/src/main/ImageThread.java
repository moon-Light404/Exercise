/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;


import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataOutput;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;

/**
 * 用来发送图片数据,
 * @author jun Ding
 */
public class ImageThread implements Runnable{
    DataOutputStream dos = null;
    int sleepTime = 30;
    public ImageThread(DataOutputStream ds,int sleepTime) {
        this.dos = ds;
        this.sleepTime = sleepTime;
    }
    
    
    @Override
    public void run() {
        try {
            Robot robot = new Robot();
            Rectangle rec = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
            BufferedImage image;
            byte[] imageBytes;
            // 一直循环发送图片数据
            while(true) {
                image = robot.createScreenCapture(rec);
                imageBytes = getImageBytes(image);
                dos.writeChar(65); // 'A' 表示发送图片
                dos.writeInt(imageBytes.length);
                dos.write(imageBytes);
                dos.flush();
                // 线程睡眠，调节帧率
                Thread.sleep(sleepTime);
            }
        } catch (AWTException ex) {
//            Logger.getLogger(ImageThread.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
//            Logger.getLogger(ImageThread.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
//            Logger.getLogger(ImageThread.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    /**
     * 
     * @param image 要压缩的图片
     * @return 图片的byte数组
     */
    public byte[] getImageBytes(BufferedImage image) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "jpeg", baos);
        return baos.toByteArray();
        //        JPEGImageEncoder jpegd = JPEGCodec.createJPEGEncoder(baos);
//        // 压缩image
//        jpegd.encode(image);
//        // 转换成byte数组
//        return baos.toByteArray();
    }
}

