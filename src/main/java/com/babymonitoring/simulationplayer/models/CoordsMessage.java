package com.babymonitoring.simulationplayer.models;

import java.util.UUID;

public class CoordsMessage extends Message {
    int X;
    double Y;

    public CoordsMessage(UUID userId, int xCoord, double yCoord) {
        UserId = userId;
        X = xCoord;
        Y = yCoord;
    }

    public void setX(int x) {
        X = x;
    }

    public int getX() {
        return X;
    }

    public void setY(double y) {
        Y = y;
    }

    public double getY() {
        return Y;
    }
}