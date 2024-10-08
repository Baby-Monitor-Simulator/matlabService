package com.babymonitoring.simulationplayer.models;

import java.util.UUID;

public class TextMessage extends Message {
    String Msg;

    public TextMessage (String msg) {
        Msg = msg;
    }

    public TextMessage (UUID userId, String msg) {
        UserId = userId;
        Msg = msg;
    }

    public void setMessage(String msg) {
        Msg = msg;
    }

    public String getMessage() {
        return Msg;
    }
}
