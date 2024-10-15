package com.babymonitoring.simulationplayer.models.results;

import com.fasterxml.jackson.annotation.JsonProperty;

public class FHRResult extends Result {
    @JsonProperty("heartRate")
    public double heartRate;
    public FHRResult (double timeSpan, double heartRate) {
        this.timeSpan = timeSpan;
        this.heartRate = heartRate;
    }
}
