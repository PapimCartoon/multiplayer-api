package come2play_as3.pseudoCode.tictactoe
{
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	import come2play_as3.pseudoCode.SimplifiedClientGameAPI;
	

public class PseudoTicTacToe extends SimplifiedClientGameAPI{
	
	public function PseudoTicTacToe()
	{
		(new GameMove).register();
	}
  public var turnNumber:int;
  
  public function getTurnOfId():int {
    return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
  }
  public function getEntryKey():String {
    return ""+turnNumber;
  }
  public function isMyTurn():Boolean {
    return getTurnOfId()==myUserId;
  }
  
  public function startMove():void {
    doAllSetTurn(getTurnOfId(), -1);
    if (isMyTurn()) {
      // allow the player to select his game move (row&col to place his marker)
    }
  }  
  public function performMove(gameMove:GameMove):void {
    // update the logic and the graphics
    turnNumber ++; // advance the turn
    var isGameOver:Boolean;
    //checks if the game is over
    if (!isGameOver) {
      startMove();
    } else {
      var finishedPlayers:Array/*PlayerMatchOver*/ = [];
      for each (var playerId:int in allPlayerIds) {
        var score:int, potPercentage:int;
        // set the score and potPercentage for playerId
        finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
      }
      doAllEndMatch(finishedPlayers);
    }
  }
  public function userMadeHisMove(gameMove:GameMove):void {
    doStoreState([ UserEntry.create(getEntryKey(), gameMove, false) ]);
  }
  
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    turnNumber = 0;
    startMove();
  }
  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    require(entry.storedByUserId==getTurnOfId());
    require(entry.key==getEntryKey());
    require(entry.visibleToUserIds == null);
    var gameMove:GameMove = entry.value as GameMove;
    performMove(gameMove);
  } 
}
}