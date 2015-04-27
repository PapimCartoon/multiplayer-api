
```
class ServerEntry { var key:Object, var value:Object, var storedByUserId:int, var visibleToUserIds:Array/*int*/, var changedTimeInMilliSeconds:int; }
```

### Parameters ###

**key :**  an Object by which the `ServerEntry`  will be called.

**value :**  the value of this `ServerEntry` .

**storedByUserId :**  the id of the user which stored this `ServerEntry`  .

**visibleToUserIds :**  users which will receive the `ServerEntry`   `value` and not null.

if `visibleToUserIds` is null all users will receive the value, if it's an empty Array

then none of the users will receive the value.

**changedTimeInMilliSeconds :**  how much time has passed since the beginning of the game

till this `ServerEntry` was stored.

### Creation ###

**You should not create serverEntries**