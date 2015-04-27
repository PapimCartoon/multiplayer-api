
```
class UserEntry{var key:Object, var value:Object, var isSecret:Boolean = false;}
```

### Parameters ###

**key :**  the key of the [ServerEntry](ServerEntry.md) that will be created, if such a key exists it will be overwritten.

**value :**  the value of the [ServerEntry](ServerEntry.md) that will be created, if null it will delete an existing key.

**isSecret :**  will the data in the [ServerEntry](ServerEntry.md)  be secret.

### Creation ###

To create a `UserEntry` instance you must use it's create function and not a constructor:

```
UserEntry.create(key,value, isSecret);
```