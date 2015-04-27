
```
gotUserInfo(userId:int, infoEntries:Array/*InfoEntry*/) 
```

### Description ###

`gotUserInfo` is called for each user connecting to the game, and transferees the user's specific data, such as: name, avatar, credibility etc.
it will be called for each user that connects (whether that user will be a player or viewer), and whenever the user info changes (e.g., if the user changed his nick name).

see also [gotUserDisconnected](gotUserDisconnected.md)

### Parameters received ###

userId - the userId of the user the call is about.

infoEntries -  an Array of [InfoEntry](InfoEntry.md) elements, each containing a key and its corresponding value.

### Available keys ###

All keys provided have a static String representing them in the [ClientGameAPI](ClientGameAPI.md), the available static string are:

  1. **USER\_INFO\_KEY\_name :**  The nick name of the user.
  1. **USER\_INFO\_KEY\_avatar\_url :** Full URL of the avatar of the user.
  1. **USER\_INFO\_KEY\_supervisor :** What is the supervisor status of this user (either! NormalUser, MiniSupervisor, Supervisor, or Admin).
  1. **USER\_INFO\_KEY\_credibility :** The credibility of the user is a number between 0 and 100.
  1. **USER\_INFO\_KEY\_game\_rating:** The skill of the user in the specific game, when 1500 means neutral

### Important note 1: ###

The game may not get `gotUserInfo` for all the `userIds` in the match state of some games, because some users may have already disconnected.

For example, imagine a game of poker with 5 players, where 2 players disconnected, and now the game is saved.

When the game is loaded by the remaining 3 players, then the game will get:
  * `gotUserInfo` for the 3 players that loaded the saved game,
  * [gotMatchStarted](gotMatchStarted.md) where `allPlayerIds` includes the 5 players and `finishedPlayerIds` is the 2 players that disconnected and `serverEntries` that includes also the state those 2 players that disconnected.

Therefore the game should not _require_ the existence of [userInfo](userInfo.md) to display the match state, and if some info is missing, the game should use default values.

### Important note 2: ###

The container may decide to do a _player switch_,
i.e., replace a player (that disconnected or chose to lose) by a viewer.

In such a case, the container will simply replace the `userId` of the viewer by the `userId` of the player, and will simply call `gotUserInfo` with the info of the viewer.

Therefore you should not store user info in the match state, see [doStoreState](doStoreState.md).