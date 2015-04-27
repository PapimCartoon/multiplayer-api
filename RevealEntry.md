
```
class RevealEntry{var key:Object, var userIds:Array/*int*/  = null, var depth:int  = 0;}
```

### Parameters ###

**key :**  the key of the [ServerEntry](ServerEntry.md) to reveal.

**userIds :**  an array of user ids to reveal the [ServerEntry](ServerEntry.md) to, if null the [ServerEntry](ServerEntry.md) will be revealed to all the users.

**depth :**  in case depth is greater than 0 the value of the revealed [ServerEntry](ServerEntry.md) is counted as a pointer to the key of the next [ServerEntry](ServerEntry.md).

### Example: ###


if you send doAllRevealState(RevealEntry.create("guess7", null , 1))

And the server has a [ServerEntry](ServerEntry.md) with the key "guess7" with the value "WrongGuess",

Then instead of getting the [ServerEntry](ServerEntry.md) with the key "guess7",

You will get a [ServerEntry](ServerEntry.md) with the key "WrongGuess".

The bigger the number in the depth the more times the value will be used as a pointer to the next [ServerEntry](ServerEntry.md) key.


### Creation ###

To create a `RevealEntry` instance you must use it's create function and not a constructor:

```
RevealEntry.create(key,userIdsToReveal,depth);
```