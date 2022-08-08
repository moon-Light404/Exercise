/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import java.io.Serializable;

/**
 *
 * @author jun Ding
 */
public class KeyInfo implements Serializable{
    private static final long serialVersionUID = 1L;
    private int event;
    private int key_code;
    
    public KeyInfo(int event,int key_code) {
        this.event = event;
        this.key_code = key_code;
    }

    public int getEvent() {
        return event;
    }

    public void setEvent(int event) {
        this.event = event;
    }

    public int getKey_code() {
        return key_code;
    }

    public void setKey_code(int key_code) {
        this.key_code = key_code;
    }
    
}
