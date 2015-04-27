
```
class PlayerMatchOver{ playerId:int, score:int, potPercentage:int}
```
**playerId :**  an id of a finishing player.


**score :**   determines the winners and losers in the match.

The user with the highest score is the winner, and if all scores are identical than we have a tie.

The rating of the players is affected by the relative differences in the scores.


**potPercentage :**  determines how the stake (or betting pot) should be divided among the players,

And it is a number between -1 and 100.

If `potPercentage` is -1, then the player should get his stake back (e.g., if the game was tied).

Otherwise, `potPercentage` represents the percentage of the pot that the player should receive.



### example : ###
Let's take a game with stakes of 100 credits,

If the first player finishing  the game got potPercentage of 30,  he will receive  30 credits.

The second player finishing will receive a relative pot Percentage, meaning that if his potPercentage is 30 as well he will only get 21 credits.