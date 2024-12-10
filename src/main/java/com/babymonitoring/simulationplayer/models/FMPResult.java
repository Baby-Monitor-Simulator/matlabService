package com.babymonitoring.simulationplayer.models;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.UUID;

public class FMPResult {
    @JsonProperty("upResult")
    public UPResult[] upResult;
    @JsonProperty("fhrResult")
    public FHRResult[] fhrResult;
    @JsonProperty("mapResult")
    public MAPResult[] mapResult;
    @JsonProperty("o2PResult")
    public O2PResult[] o2PResult;

    public FMPResult () {}

    public FMPResult (FHRResult[] fhrResult, MAPResult[] mapResult, O2PResult[] o2PResult, UPResult[] upResult) {
        this.fhrResult = fhrResult;
        this.mapResult = mapResult;
        this.o2PResult = o2PResult;
        this.upResult = upResult;
    }

//    @Override
//    public String toString()
//    {
//        return "address";
//    }
}
