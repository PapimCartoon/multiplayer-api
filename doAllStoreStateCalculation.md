
```
doAllStoreStateCalculation(requestId:int,userEntries:Array/*UserEntry*/)
```


### Description ###

Call this function from a [gotRequestStateCalculation](gotRequestStateCalculation.md) to transferred the data from the calculator to the game's
players.

This function will trigger a [gotStateChanged](gotStateChanged.md)

For more information about storing information go to [MatchState](MatchState.md).

### Parameters ###

requestId - the requestId received from the [gotRequestStateCalculation](gotRequestStateCalculation.md) callback.

userEntries - an Array of [UserEntry](UserEntry.md) elements, containing the data that will be sent to the users
via a [gotStateStateChange](gotStateStateChange.md) callback.

### Triggered gotStateChange on users ###

an array of [ServerEntry](ServerEntry.md) with the results of the state calculations made by the calculator flash,
all the calculated [ServerEntry](ServerEntry.md) elements will have a storedByUserId of -1

### Example ###

lets suppose this is a mine sweeper calculator.
we expect a random number stored by the server via a [doAllRequestRandomState](doAllRequestRandomState.md)

```
override public function gotRequestStateCalculation(serverEntries:Array):void
{
	/*
	check if the serverEntries received from  the users are legal
	do whatever calculations needed 
	and then store them using 
	*/
	if (serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"If the storedByUserId is different from -1,then this was not saved by the server and player which saved it there probably broke protocol");
	doAllStoreStateCalculation(createdUserEntries);
}
```



### Why should I use this? ###



When the calculator is finished with the data calculations he was given, he cannot simply use [doStoreState](doStoreState.md) to commit the calculations he has made,

Because he is not an active player/viewer in the game.

Therefore the calculator will use a special function called `doAllStoreStateCalculation` which acts similarly to the [doAllStoreState](doAllStoreState.md) function,

Only instead of saving the game data into the calculator server state, the calculator saves it into the game state of the players which called the [doAllRequestStateCalculation](doAllRequestStateCalculation.md).
