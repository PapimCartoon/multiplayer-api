
```
doAllRevealState(revealEntries:Array/*RevealEntry*/)
```


### Description ###

Call this function to reveal a secret stored state to a subset of users

This function will trigger a [gotStateChanged](gotStateChanged.md)

For more information about storing information go to [MatchState](MatchState.md).

### Parameters ###

revealEntries - an Array of [RevealEntry](RevealEntry.md) elements each holding a key pointing to the [ServerEntry](ServerEntry.md) to be revealed,
userIds  Array to reveal the state represented by the key to,
and a depth element describing if the [ServerEntry](ServerEntry.md) value should be used as a pointer to the next [ServerEntry](ServerEntry.md).


### Triggered gotStateChange on users ###

For each [RevealEntry](RevealEntry.md) element all the game users will get all the serverEntries changed by the call
Each [ServerEntry](ServerEntry.md) will have a storedByUserId of -1

### Example ###

Imagine we have a simple guessing game in which we have a secret number between 0 - 100,all the users store their guesses for that number.
and then the user closest to the number wins.

```
var guesses:Array = new Array;
var allPlayerIds:Array;
var myUserId:int;

/*
this function will be called from the user inputting a number to our game

*/
public function userInput(guessedNumber:int):void
{
	var keyObj:Object = new Object();
	keyObj.myUserId = myUserId;
	keyObj.type = "guess";
	var valueObj:Object = new Object();
	valueObj.myUserId = myUserId;
	valueObj.guessedNumber = guessedNumber;
	var userEntry:UserEntry = UserEntry.create(keyObj,valueObj,false);
	doStoreState(userEntry);
}

override public function gotMyUserId(myUserId:int):void
{
	this.myUserId = myUserId;
}

override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, extraMatchInfo:Object, matchStartedTime:int, serverEntries:Array):void
{
	this.allPlayerIds = allPlayerIds;
	doAllRequestRandomState("randomNumber",true);//will store a random number
}

override public function gotStateChanged(serverEntries:Array):void
{
	var serverEntry:ServerEntry = serverEntries[0];
	if(serverEntry.key == "randomNumber")
	{
		if (serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"If the storedByUserId is different from -1,then this was not saved by the server and player which saved it there probably broke protocol");
		if(serverEntry.value !=null)
		{
			var distanceFromGuess:int = 101;
			var userId:int;
			for each(var userGuess:Object in guesses)
			{
				var tempDistanceFromGuess = Math.abs((serverEntry.value - userGuess.guessedNumber));
				if (distanceFromGuess > tempDistanceFromGuess)
				{
					userId = userGuess.myUserId
					distanceFromGuess = tempDistanceFromGuess;
				}
			}
			/*
			
			call here the appropriate doAllEndMatch
			*/
			trace(userId+" : has Won")
		}
	}
	else if(serverEntry.key.type == "guess")
	{
		if (serverEntry.storedByUserId != serverEntry.key.myUserId) doAllFoundHacker(serverEntry.storedByUserId,"player tried to save a guess in someone else name");
		guesses.push(serverEntry.value);
		if(guesses.length == allPlayerIds.length)
		{
			var revealEntry:RevealEntry = RevealEntry.create("randomNumber",null,0);
			doAllRevealState([revealEntry]);
		}
	}

}
```


