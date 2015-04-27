
```
doStoreState(userEntries:Array/*UserEntry*/,revealEntries:Array/*RevealEntry*/ = null)
```

### Description ###

Use this function to store the match state on the server.
Both players and viewers can store match state, and only when the match is in progress.
However, a viewer cannot override a stored `key`, whereas players can use the same key-space.
When the match ends, the state is cleared.

This function is also used to reveal specific entries that are already stored on the server.

This function will trigger a [gotStateChanged](gotStateChanged.md)

For more information about storing information go to [MatchState](MatchState.md).

### Parameters ###

userEntries - an Array of [UserEntry](UserEntry.md) elements to be stored on the server.

revealEntries - an Array of [RevealEntry](RevealEntry.md) elements to be revealed, if  this Array is not null the userEntries array will have to contain at least one entry,
This is because you will never reveal an entry without sending the rest of the user input if you intend to make your game secure.

### Triggered gotStateChange on users ###

An array of [ServerEntry](ServerEntry.md) elements, each representing a [UserEntry](UserEntry.md) stored,or a [ServerEntry](ServerEntry.md) revealed
where the entries stored by the user will have storedByUserId with the id of the storing user,and the revelaed entries will have storedByUserId of -1.
all the entries will either have the stored value, or null if the value is still secret to the user.

### Example ###

player 1 stores a secret number after receiving user input through the onUserInput function

```

public function onUserInput(num:int):void
{
	var keyObj:Object = new Object();
	keyObj.userId = myUserId;
	keyObj.type = "number";
	var userEntry:UserEntry = UserEntry.create(keyObj,num,false);
	var userEntries:Arrat = new Array();
	userEntries.push(userEntry);
	doStoreState(userEntries);
}


override public function gotStateChanged(serverEntries:Array):void
{
	var serverEntry:ServerEntry = serverEntries[0];
	if(serverEntry.type == "number")
	{
		if (serverEntry.storedByUserId != serverEntry.key.userId) doAllFoundHacker(serverEntry.storedByUserId,"player tried to store a value on someone else's key");
		trace("player " + serverEntry.key.userId + " typed "+serverEntry.value);
	
	}
	
}

```