MultiHome API
=============
The MultiHome mod provides a simplistic API allowing creation, deletion, access, and listing of homes as documented below. __Note__: Unless otherwise mentioned, the function documented below return values suitable so as to allow directly returning from chatcommand definitions so as to print to chat (returns two values, success and message).

`multihome.set(player, name)`

* Set a home at the player's current position (will overwrite previous homes)
* `player`: PlayerRef
* `name`: Home name

`multihome.remove(player, name)`

* Remove a player's home
* `player`: PlayerRef
* `name`: Home name

`multihome.get(player, name)`

* Returns the position of the home specified or `nil`
* `player`: PlayerRef
* `name`: Home name

`multihome.get_default(player)`

* Returns a "default" home if the player has only one home set
* Allows the player to be automatically teleported without specifying the home name
* `player`: PlayerRef

`multihome.list(player)`

* List a player's homes in format suitable for chat
* `player`: PlayerRef

`multihome.go(player, name)`

* Teleport a player to the home specified
* `player`: PlayerRef
* `name`: Home name
