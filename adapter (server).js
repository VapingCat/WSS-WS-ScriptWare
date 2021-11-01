// Declaration of packages
const WebSocketServer = require('ws').Server;
const W3CWebSocket = require('websocket').w3cwebsocket; 

// Dynamic variables
var cClient;
var cWs;

// Initialize ws server
const wsServer = new WebSocketServer({ port: 6969 });

console.log('Initialized WS Server.')

// Wait for connections
wsServer.on('connection', function(ws) {
    // Connection was recieved
    console.log('Connection accepted.');
    cWs = ws

    // Wait for message
    ws.on('message', function(message) {
        const decoded = JSON.parse(message)
        //ws.send(message); // leftover from echo protocol example

        // we want to check for the correct arguments
        if (!decoded.type && !decoded.data) return;
        const data = decoded.data;
    
        switch (decoded.type) {
            default:
                cClient.send(JSON.stringify({
                    type: 'Syntax',
                    data: '\'type\' is not valid.'
                }))
                break;
            case 'NewClient':
                if (!data.url) return;
                cClient = new W3CWebSocket(data.url); // create new websocket
                onNewClient() // run onNewClient
                break;
            case 'SendClient':
                if (!data) return;
                cClient.send(JSON.stringify(data)); // send client data
                break;
            case 'CloseClient':
                cClient.close(); // close client
                cClient = null;
                break;
        }
    });
    
    ws.send(JSON.stringify({ // ran on connection
        type: 'OnConnection',
        data: 'Connected to Adapter'
    }))

    ws.on('close', function() {
        console.log('Peer disconnected.');
        cClient.close()
        cClient = null;
    });
});

function onNewClient() { // ran on client creation
    cClient.onerror = () => cWs.send(JSON.stringify({
        type: 'OnError' // send client error
    }));
    
    cClient.onopen = () => cWs.send(JSON.stringify({
        type: 'OnOpen' // send client onopen
    }));
    
    cClient.onclose = function () {
        cWs.send(JSON.stringify({
            type: 'OnClose' // send when client close
        }));
        cClient = null;
    }
    
    cClient.onmessage = function(e) {
        // make sure data is string
        if (typeof e.data !== 'string') return

        cWs.send(JSON.stringify({ // send client message
            type: 'OnMessage',
            data: e.data
        }))
    };
}
