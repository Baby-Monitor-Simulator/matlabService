package com.babymonitoring.simulationplayer.models.results;

import com.fasterxml.jackson.annotation.JsonProperty;

public class O2PResult extends Result {

    @JsonProperty("o2Pressure")
    public double o2Pressure;
    public O2PResult (double timeSpan, double o2Pressure) {
        this.timeSpan = timeSpan;
        this.o2Pressure = o2Pressure;
    }
}
