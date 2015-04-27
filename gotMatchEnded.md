
```
gotMatchEnded(finishedPlayerIds:Array/*int*/)
```

### Description ###

Called when one or more users finish the game, either by winning losing or disconnecting.

see also [doAllEndMatch](doAllEndMatch.md)

### Parameters received ###

finishedPlayerIds - an Array of all the users which finished the game.

### Example ###

if player 1 wins the game and the game goes on, then what you will get is
finishedPlayerIds with the number 1, representing the finishing players ID.
