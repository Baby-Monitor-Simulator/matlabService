package com.babymonitoring.simulationplayer.service;


import com.babymonitoring.simulationplayer.config.RabbitMQConfig;
import com.babymonitoring.simulationplayer.models.events.ParticipantAction;
import com.babymonitoring.simulationplayer.models.events.SimulationUpdate;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMQSenderService {

    private final RabbitTemplate rabbitTemplate;

    @Autowired
    public RabbitMQSenderService(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void sendSimulationUpdate(SimulationUpdate update) {
        System.out.println("Sending simulation update: " + update);
        rabbitTemplate.convertAndSend(RabbitMQConfig.LOBBY_QUEUE, update);
    }
}

