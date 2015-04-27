
```
T.custom(key:String,defaultValue:Object)
```

### Description ###

This function helps you get custom values, custom values are values which you set in the game
and are customizable in an outer interface which makes your game more adaptable and thus more successful with channel owners

### Parameters ###

key - they of the customizable value.

defaultValue - the value that should be used in case no value was choose.

### Returns ###

An Object containing value set from outside, in case no value was set you will get your default value.


### Example ###

You want to post a game of Sudoku will have an adaptable challenge rating thus fitting game channels with novice players and experienced ones.

what you should do is after or during the [gotCustomInfo](gotCustomInfo.md) callback you should call:
```
T.custom("difficulty","Easy");
```

This will let you set the difficulty from outside ,and in case one was not setup, it will treat it as an easy game.