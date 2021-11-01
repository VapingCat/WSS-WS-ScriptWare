-- // WSS Client Implementation

-- JSON Package
local JSON = {}

JSON.parse = function(json)
	return game:GetService('HttpService'):JSONDecode(json)
end

JSON.stringify = function(json)
	return game:GetService('HttpService'):JSONEncode(json)
end

-- Connection to Adapter
local Port = 6969
local Adapter = WebSocket.connect('ws://localhost:'..Port)

local Types = {}

function Send(type, data)
	Adapter:Send(JSON.stringify({
		type = type,
		data = data
	}))
end

-- Adapter Connected
function Types.OnConnection(data)
	warn(data)
end

local OnMessageBindable = Instance.new('BindableEvent')
local OnCloseBindable = Instance.new('BindableEvent')
local OnErrorBindable = Instance.new('BindableEvent')
local OnOpenBindable = Instance.new('BindableEvent')

-- Fire Events
function Types.OnOpen()
	OnOpenBindable:Fire()
end

function Types.OnError()
	OnErrorBindable:Fire()
end

function Types.OnClose()
	OnMessageBindable:Fire()
end

function Types.OnMessage(data)
	OnMessageBindable:Fire(data)
end

function Types.Syntax(data)
	warn('Adapter: '..data)
end

-- Error on unexpected Adapter Close
Adapter.OnClose:Connect(function()	
	error('Unexpected Close.')
end)

-- Call the corrosponding type
Adapter.OnMessage:Connect(function(message)
	local decoded = JSON.parse(message)
	
	local Funct = Types[decoded.type]
	if Funct then
		Funct(decoded.data)
	else
		warn('Adapter Recieved: '..message)
	end
end)

-- Create the WSS package
local WSS = {}

function WSS:Connect(url)
	Send("NewClient", {
		url = url
	})
end

function WSS:Send(message)
	Send("SendClient", {
		data = message
	})
end

function WSS:Close(message)
	Send("CloseClient")
end

WSS.OnMessage = OnMessageBindable.Event
WSS.OnClose = OnCloseBindable.Event
WSS.OnError = OnErrorBindable.Event
WSS.OnOpen = OnOpenBindable.Event

-- // End Of Client
