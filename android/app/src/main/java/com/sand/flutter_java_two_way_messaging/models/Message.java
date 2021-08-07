package com.sand.flutter_java_two_way_messaging.models;

public class Message {
    private String text;
    private int value;

    public Message(String text, int value) {
        this.text = text;
        this.value = value;
    }

    public String getText() {
        return text;
    }

    public int getValue() {
        return value;
    }
}
