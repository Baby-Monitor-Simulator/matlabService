package com.babymonitoring.simulationplayer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


@SpringBootApplication
public class SimulationplayerApplication {

	public static void main(String[] args) {
		SpringApplication.run(SimulationplayerApplication.class, args);

		Thread newThread = new Thread(() -> {
            ProdSimulation sim = new ProdSimulation();
            sim.Chart();
        });
		newThread.start();
	}

}

