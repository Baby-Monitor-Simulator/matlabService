const stompClient = new StompJs.Client({
    brokerURL: 'ws://localhost:8080/ws-lobby'
});

stompClient.onConnect = (frame) => {
    setConnected(true);
    console.log('Connected: ' + frame);
    stompClient.subscribe('/lobby/' + $("#userId").val(), (lobby) => {
        checkMessage(JSON.parse(lobby.body));
    });
};

stompClient.onWebSocketError = (error) => {
    console.error('Error with websocket', error);
};

stompClient.onStompError = (frame) => {
    console.error('Broker reported error: ' + frame.headers['message']);
    console.error('Additional details: ' + frame.body);
};

function setConnected(connected) {
    $("#connect").prop("disabled", connected);
    $("#disconnect").prop("disabled", !connected);
    if (connected) {
        $("#lobbyTraffic").show();
        $("#simCoords").show();
    }
    else {
        $("#lobbyTraffic").hide();
        $("#simCoords").hide();
    }
    $("#lobbies").html("");
    $("#coords").html("");
}

function connect() {
    stompClient.activate();
}

function disconnect() {
    stompClient.deactivate();
    setConnected(false);
    console.log("Disconnected");
}

function sendUserId() {
    stompClient.publish({
        destination: "/app/simulation",
        body: JSON.stringify({'userId': $("#userId").val()})
    });
}

function checkMessage(body) {
    if (body.message != undefined && body.message != "") { //If lobby traffic
        console.log("Message:" + body);
        showLobbies(body.message);
    }
    else if (body.x != undefined && body.y != undefined) { //Else if coords
        console.log("Coords:" + body);
        showCoords(body);
    }
    else { //Else junk
        console.log("ERROR!!!")
    }
}

function showLobbies(message) {
    $("#lobbies").append("<tr><td>" + message + "</td></tr>");
}

function showCoords(body) {
    $("#coords").append("<tr><td>" + "X:" + body.x + " Y:" + body.y + "</td></tr>");
}

$(function () {
    $("form").on('submit', (e) => e.preventDefault());
    $( "#connect" ).click(() => connect());
    $( "#disconnect" ).click(() => disconnect());
    $( "#send" ).click(() => sendUserId());
});