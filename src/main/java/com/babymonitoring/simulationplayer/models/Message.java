package com.babymonitoring.simulationplayer.models;

import java.util.UUID;

public class Message {
    UUID UserId;

    public Message () {}

    public Message (UUID userId) {
        UserId = userId;
    }

    public void setUserId(UUID userId) {
        UserId = userId;
    }

    public UUID getUserId() {
        return UserId;
    }
}