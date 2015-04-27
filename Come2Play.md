This Google code project is focused on the container that supports the Multiplayer API.

[Come2Play, http://www.come2play.com](http://www.come2play.com), is a company that freely distributes multiplayer games (as widgets and in social networks) and share the advertising revenue with the game developers.
[Come2Play](http://www.come2play.com) officially endorse this API, and has opened sourced its [Emulator](Emulator.md) with the purpose of creating an open source standard for developing multiplayer games that other companies can endorse as well.

You can visit [Come2Play](http://www.come2play.com) to submit your game, and distribute it on social networks and widgets.

[Come2Play](http://www.come2play.com) developed a _container_ for games that saves a lot of development time for game developers.
The _container_ is in charge of:
  * communicating with the gaming server
  * displaying the players and viewers information
  * displaying a common chat area for all users
  * displaying game messages, e.g., if a player disconnects or the match ends
  * allowing the players to bet on the outcome of the game and change the stakes
  * allowing the players to end the match in a tie, to cancel the match, or to save the match
  * handling turn-based games, i.e., games that proceeds in turns where only one player at a time has the turn. The _container_ limits the time per move or per match, displays who has the current turn, how much time he has left to make his move, etc.