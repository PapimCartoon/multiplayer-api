
```
doAllShuffleState(keys:Array/*Object*/)
```

### Description ###

Call this function to shuffle a set of server entries represented by the keys you send

This function will trigger a [gotStateChanged](gotStateChanged.md)

For more information about storing information go to [MatchState](MatchState.md).

### Parameters ###

keys - an Array of Objects each representing a key to be shuffled by the server.


### Triggered gotStateChange on users ###

The players will get an Array of server entries corresponding to the keys sent
with each having a value of null and storedByUserId of -1


### Example ###

all players store the cards needed for a game of Poker using a [doAllStoreState](doAllStoreState.md) on the server,

each card in a different [UserEntry](UserEntry.md),

and then all the users call `doAllShuffleState` on the keys of the stored cards,

the `doAllShuffleState` function will shuffle the cards between themselves and turn the server entries that were stored and shuffled by the users into secret ones.


### Why should I use this? ###


Some games that are developed need to have the ability to shuffle values.
A single player cannot be trusted to shuffle the values as he may be a hacker, and therefore
we must do the shuffle on the server.