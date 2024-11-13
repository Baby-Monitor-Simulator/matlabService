package com.babymonitoring.simulationplayer.config;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnExpression("!'${spring.rabbitmq.host}'.isEmpty()")
public class RabbitMQConfig {

    public static final String TOPIC_EXCHANGE_NAME = "topic-exchange";
    public static final String MATLAB_QUEUE = "Matlab";
    public static final String LOBBY_QUEUE = "Lobby";

    @Bean
    public TopicExchange topicExchange() {
        return new TopicExchange(TOPIC_EXCHANGE_NAME);
    }

    @Bean
    public Queue matlabQueue() {
        return new Queue(MATLAB_QUEUE, true);
    }

    @Bean
    public Queue lobbyQueue() {
        return new Queue(LOBBY_QUEUE, true);
    }

    @Bean
    public Binding lobbyQueueBinding(Queue lobbyQueue, TopicExchange topicExchange) {
        // Bind the simulation queue to the topic exchange for "lobby.participantAction"
        return BindingBuilder.bind(lobbyQueue).to(topicExchange).with("lobby.participantAction");
    }


    @Bean
    public Jackson2JsonMessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(messageConverter());
        return rabbitTemplate;
    }
}
