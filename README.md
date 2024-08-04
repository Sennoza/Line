<div align="center">
	<img align="center" src="./media/lineLogo.png" width=300>

# Line
---
### A very simple and undoubtedly very stupid remote wrapper for Roblox.
---
</div>

Usage:

*Place "Line.luau" into ReplicatedStorage*

*Create a second module to store your remote layout*
```lua
-- Module in Replicated Storage
local Line = require(game.ReplicatedStorage.Line)

 -- Return remote hierarchy table
return {
	someNamespace = {
		someEvent = Line.event()
	},

	someOtherNamespace = {
		someEvent = line.event()
	},
}
```

*Access from server and client scripts*
```lua
-- Server Script
local Line = require(game.ReplicatedStorage.Line)

Line.someNamespace.someEvent.listen(function(client: Player, message: string)
	print(client.Name, "Said", message)
end)
```
```lua
-- Client Script
local Line = require(game.ReplicatedStorage.Line)
line.someNamespace.someEvent.sendServer("Hello!")
```
---

Line uses additive instance naming (foolishly) so your remote hierachy can be as many namespaces deep as you wish.
