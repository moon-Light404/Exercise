/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOError;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author jun Ding
 */
public class receiveFile implements Runnable{
    private boolean send = false;
    private String fileDir = null;
    private Map fileMap = new HashMap<>();
    public receiveFile(Map fileMap,String fileDir) {
        this.fileMap = fileMap;
        this.fileDir = fileDir;
    }

    
    @Override
    public void run() {
        File file = new File(fileDir);
        if(!file.exists()) {
            file.mkdirs();
        }
        try {
            byte[] bytes = (byte[]) fileMap.get("filecontent");
            String fileName = (String) fileMap.get("filename");
            file = new File(fileDir+File.separator+fileName);
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(bytes);
            fos.flush();
            fos.close();
            ClientUI.txtInfo.append("文件接收成功，地址:" + fileDir+File.separator+fileName);
         }catch(IOException e) {
             e.printStackTrace();
             ClientUI.txtInfo.append("文件接收失败" + e.getMessage());
         }
    }
    public String getFileDir() {
        return fileDir;
    }

    public void setFileDir(String fileDir) {
        this.fileDir = fileDir;
    }
}
