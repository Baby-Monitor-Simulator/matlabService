package com.babymonitoring.simulationplayer.models.results;

import com.fasterxml.jackson.annotation.JsonProperty;

public class UPResult extends Result {
    @JsonProperty("uPressure")
    public double uPressure;
    public UPResult (double timeSpan, double uPressure) {
        this.timeSpan = timeSpan;
        this.uPressure = uPressure;
    }
}
