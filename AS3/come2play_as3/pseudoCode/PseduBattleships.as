package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	
public class PseduBattleships extends SimplifiedClientGameAPI {
  public var turnNumber:int;
  public var shipStatesCommited:int;
  public var isGameOver:Boolean;
  
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
  public function performMove(gameMove:GameMove):void
  {
    var isHit:Boolean;
    //check if the player hit your ship
    var gameData:GameData=new GameData(gameMove,isHit);
    doStoreState([new UserEntry(gameMove.objectKey(),gameData,false)]);
    updateHits(gameData);
  }
  public function updateHits(gameData:GameData):void
  {
  	if(gameData.isHit)
	{
		//make graphic hit
		//check if game is over
		if (isGameOver) {
			var shipStatesToReveal:Array=[];
			for each(var playerId:int in allPlayerIds)
			  shipStatesToReveal.push(new RevealEntry("ships_"+playerId,allPlayerIds));
			doAllRevealState(shipStatesToReveal);
		}
  	}
  	else
  	{
  	  //make graphic miss
  	  turnNumber ++; // advance the turn
  	}
  	if (isMyTurn()) {
      // allow the player to select his game move (row&col to place his marker)
    }
  }
  public function userMadeHisMove(gameMove:GameMove):void {
    doStoreState([ new UserEntry(gameMove.objectKey(), gameMove, false) ]);
    //performMove(gameMove);
  }
  public function userSetHisBoard(allShips:Array):void
  {
  	doStoreState([new UserEntry("ships_"+myUserId,allShips,true)]);
  	shipStatesCommited++;
  	if(shipStatesCommited == allPlayerIds.length)
  		startMove();
  }
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    // allow user to arrange his board 
    shipStatesCommited = 0;
    turnNumber = 0;
    isGameOver = false;
    //startMove();
  }
  override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    if (entry.storedByUserId == myUserId) return; // user move is not relevent
    if(shipStatesCommited == allPlayerIds.length)
    {
    	require(entry.authorizedUserIds == null);
    	if(isGameOver)
    	{
    	  require(entry.key == ("ships_"+entry.storedByUserId));
    	  var rivalShips:Array = entry.value as Array;
    	  var isGameLegeal:Boolean;
    	  //check if the ships the rival stored correspond to his answers on your shots
    	  if(!isGameLegeal)
    	  {
    	  	doAllFoundHacker(myUserId,"rival answers dont correspond with secret state");
    	  }
    	  else
    	  {
    	    var finishedPlayers:Array/*PlayerMatchOver*/ = [];
			for each (var playerId:int in allPlayerIds) {
				var score:int, potPercentage:int;
				// set the score and potPercentage for playerId
				finishedPlayers.push( new PlayerMatchOver(playerId, score, potPercentage) );
			}
			doAllEndMatch(finishedPlayers);
    	  }
    	}
    	else
    	{	  
    	  if(entry.value is GameMove)
    	  {
    	  var gameMove:GameMove =GameMove.object2GameMove(entry.value);
    	  require(entry.storedByUserId == getTurnOfId());
    	  var gameMoveTarget:Array=entry.key.split("_");
    	  require(gameMoveTarget[0] == myUserId);
    	  require(gameMove.testKey(gameMoveTarget));
    	  performMove(gameMove); 
    	  }
    	  else
    	  {
    	  var gameData:GameData =GameData.object2GameData(entry.value);
    	  updateHits(gameData);
    	  }
    	}
    }
    else
    {
      require(entry.authorizedUserIds != null);
      require(entry.key == "ships_"+entry.storedByUserId);
      shipStatesCommited++;
      if(shipStatesCommited == allPlayerIds.length)
  		startMove();	
    }
  } 
}

}
class GameData{
  public var row:int, column:int,playerIdAttacked:int,isHit:Boolean;
  function GameData(gameMove:GameMove,isHit:Boolean) {
  	this.playerIdAttacked = gameMove.playerIdAttacked;
    this.row = gameMove.row;
    this.column = gameMove.column;
    this.isHit = isHit;
  }	
  public static function object2GameData(obj:Object):GameData {
    return new GameData(new GameMove(obj["row"], obj["column"],obj["playerIdAttacked"]) , obj["isHit"] );
  } 
}
class GameMove {
  public var row:int, column:int,playerIdAttacked:int;
  function GameMove(row:int, column:int, playerIdAttacked:int) {
  	this.playerIdAttacked = playerIdAttacked;
    this.row = row;
    this.column = column;
  }
  public function objectKey():String
  {
  	return playerIdAttacked+"_"+row+"_"+column;
  }
  public function testKey(gameMoveTarget:Array):Boolean
  {
  	return ((gameMoveTarget[0] == playerIdAttacked) && (gameMoveTarget[1] == row) && (gameMoveTarget[2] == column))
  }
  public static function object2GameMove(obj:Object):GameMove {
    return new GameMove(obj["row"], obj["column"],obj["playerIdAttacked"]);
  }     
}