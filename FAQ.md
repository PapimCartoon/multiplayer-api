### How did you ensure that people cannot break your API and cheat in games? ###

First, the Multiplayer API is only an API to write games,
i.e., if you write a game with security holes then it will be possible to cheat in.
Also, the API does not define the communication protocol with the server (it only defines the communication between the _game_ and its _container_).
On the [Come2Play](Come2Play.md) platform, the communication is encrypted and the _container_ SWF is encrypted and obfuscated.
Therefore it is unlikely that hackers will be able to cheat.

Now, suppose you wrote your game very carefully,
and checked that every message is legal,
the question becomes what happens when a player sends you an illegal message?

In [ClientGameAPI](ClientGameAPI.md) you use only client side code.
The clients should check the legality of the messages, and should call [doAllFoundHacker](doAllFoundHacker.md) if there is an illegal message.
Also, the clients agree together when the match ends, and all of them should call [doAllEndMatch](doAllEndMatch.md) with the same parameters to end the match.
If a hacker was found, a jury is selected among the other players of the game, and that jury finds the hacker in an automatic way
that is described in [The Jury game paper](http://multiplayer-api.googlecode.com/files/SecureClientGameAPI_version2.pdf).