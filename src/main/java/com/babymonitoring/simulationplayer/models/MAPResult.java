package com.babymonitoring.simulationplayer.models;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MAPResult extends Result {
    @JsonProperty("MAP")
    public double MAP;
    public MAPResult (double timeSpan, double MAP) {
        this.timeSpan = timeSpan;
        this.MAP = MAP;
    }
}
