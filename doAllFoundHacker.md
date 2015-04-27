
```
doAllFoundHacker(userId:int, errorDescription:String)
```

### Description ###

Call this function when you suspect one of the players sent a message which does not correspond with a legal move.


### Parameters ###

userId - an int representing the ID of the suspected user

errorDescription - a short description of what message was expected, or why was the move illegal.


### Example ###

lets say you expect to get an Object with a num property which is smaller then 10,what you should write
in [gotStateChange](gotStateChange.md) is:
```

override public function gotStateChanged(serverEntries:Array):void
{
	var serverEntry:ServerEntry = serverEntries[0];
	if (serverEntry.value is Object)
	{
		var obj:Object = serverEntry.value as Object;
		if (obj.num > 10)
			doAllFoundHacker(serverEntry.storedByUserId,"the user stored a num greater then 10");	
	}
}

```

### Why should I use this? ###

In [ClientGameAPI](ClientGameAPI.md) all the logic is on the client side,

Therefore the players themselves should check that the other players make only legal moves.

Both players and viewers should call `doAllFoundHacker` in case of a protocol error.

Consider a game with two players: X and Y.

Suppose that player Y stored an illegal match state.

Then player X should call `doAllFoundHacker(Y,description)`.

The server will randomly pick a jury that will judge whether
Player X or player Y is the hacker.

The jury is a set of users that are playing in another game.
The server will pass to the jury the verified match state
and then all the messages in the `unverifiedQueue`.
If all members of the jury called `doFoundHacker`,
then the server decides that player Y is a hacker.
If no member of the jury called `doFoundHacker`
then the server decides that player X is a hacker (that falsely reported on player Y).
If the jury is in disagreement, then this is a bug of the game developer,
and the game is canceled.