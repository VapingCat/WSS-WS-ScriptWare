## WS:// => WSS://
This is something I made to interact with `wss://` websockets from a `ws://` connection.
I made it originally for ScriptWare with Lua, but it can be used elsewhere if nescasary.

`adapter (client).lua` holds the client that is able to connect to the adapter.
`adapter (server).js` contains the adapter itself, with comments for clarity.

This only supports 1 connection and 1 websocket at a time.
**Use at your own risk.**
