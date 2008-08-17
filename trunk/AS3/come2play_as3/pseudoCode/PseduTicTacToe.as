package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	
public class PseduTicTacToe extends SimplifiedClientGameAPI {
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
        finishedPlayers.push( new PlayerMatchOver(playerId, score, potPercentage) );
      }
      doAllEndMatch(finishedPlayers);
    }
  }
  public function userMadeHisMove(gameMove:GameMove):void {
    doStoreState([ new UserEntry(getEntryKey(), gameMove, false) ]);
    performMove(gameMove);
  }
  
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    turnNumber = 0;
    startMove();
  }
  override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    if (entry.storedByUserId==myUserId) return; // already updated my move
    require(entry.storedByUserId==getTurnOfId());
    require(entry.key==getEntryKey());
    require(entry.authorizedUserIds == null);
    var gameMove:GameMove = GameMove.object2GameMove(entry.value);
    performMove(gameMove);
  } 
}
}
class GameMove {
  public var row:int, column:int;
  function GameMove(row:int, column:int) {
    this.row = row;
    this.column = column;
  }
  public static function object2GameMove(obj:Object):GameMove {
    return new GameMove(obj["row"], obj["column"]);
  }     
}