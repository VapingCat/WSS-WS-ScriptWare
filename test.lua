-- WSS client up here

-- Discord Gateway
WSS:Connect('wss://gateway.discord.gg/?v=9&encoding=json')

WSS.OnMessage:Connect(function(message)
	warn('Recieved: '..message)
    --WSS:Send('something')
end)

WSS.OnOpen:Connect(function()
	warn('WSS Opened')
end)

WSS.OnError:Connect(function()
	warn('WSS Errored')
end)

WSS.OnClose:Connect(function()
	warn('WSS Closed')
end)
