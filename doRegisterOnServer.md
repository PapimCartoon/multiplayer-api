
```
doRegisterOnServer()
```

### Description ###

The first operation that your game should call is `doRegisterOnServer()`.
Call it after your game SWF and any other resources finished loading completely.
The server may start a new match only after all players have called `doRegisterOnServer`.