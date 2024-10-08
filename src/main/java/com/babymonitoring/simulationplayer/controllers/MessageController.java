package com.babymonitoring.simulationplayer.controllers;

import com.babymonitoring.simulationplayer.Simulation;
import com.babymonitoring.simulationplayer.models.CoordsMessage;
import com.babymonitoring.simulationplayer.models.Message;
import com.babymonitoring.simulationplayer.models.TextMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Controller
public class MessageController {

    private SimpMessagingTemplate template;
    //private Simulation simulation;
    @Autowired
    public MessageController(SimpMessagingTemplate template) {
        this.template = template;
    }

    @MessageMapping("/simulation")
    public void lobby(Message message) throws Exception {
        Thread newThread = new Thread(() -> {
            try {
                //this.simulation = new Simulation(this);
                //simulation.startSimulation(10, 1000, 5, 0.5, 0, 0.01, 10, message.getUserId());
                new Simulation(this).startSimulation(10, 1000, 5, 0.5, 0, 0.01, 10, message.getUserId());
            } catch (ExecutionException e) {
                throw new RuntimeException(e);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        });
        newThread.start();
        SendText(new TextMessage(message.getUserId(),"Hello, " + HtmlUtils.htmlEscape(message.getUserId().toString()) + "!"));
    }


    public void SendText(TextMessage message) {
        this.template.convertAndSend("/lobby/" + message.getUserId(), message);
    }

    public void SendCoords(CoordsMessage message) {
        this.template.convertAndSend("/lobby/" + message.getUserId(), message);
    }

}