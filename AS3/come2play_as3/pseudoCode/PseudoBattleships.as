package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.api.auto_copied.*;
	/*****************************************
	 * The keys in the Match state:
	 * "ships_"+<playerId> : all the player secret ship positions
	 * should not be changed and will be revealed in the end of the
	 * game to check that no player has cheated.
	 * 
	 * <playerId>_<row>_<column>: GameMove
	 * holds the moves each player has performed and were not checked 
	 * by the opponent.
	 * 
	 * <playerId>_<row>_<column>: GameData 
	 * holds the moves each player has performed and were checked 
	 * by the opponent.
	 *****************************************/	
public class PseudoBattleships extends SimplifiedClientGameAPI {
  public var turnNumber:int;
  public var shipStatesCommited:int;
  
  private function getTurnOfId():int {
    return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
  }
  private function getEntryKey():String {
    return ""+turnNumber;
  }
  private function isMyTurn():Boolean {
    return getTurnOfId()==myUserId;
  }
  private function verifyGameData(gameData:GameData):Boolean
  {
  	var value:Object;
  	var gameMove:GameMove
  	for each(var serverEntry:ServerEntry in state)
  	{
  		value = SerializableClass.deserialize(serverEntry.value);
  		if(value is GameMove)
  		{
  			gameMove=value as GameMove;
  			if( (gameMove.column == gameData.column) &&
  				(gameMove.row == gameData.row) )
  				{
  					if(	(gameMove.playerAttacking == gameData.playerAttacking) &&
  						(gameMove.playerIdAttacked == gameData.playerIdAttacked) &&
  						(gameData.playerAttacking == serverEntry.storedByUserId) )
  							return true
  						else
  							return false
  				}
  		}
  	}
  	return false;
  }
  private function startMove():void {
    doAllSetTurn(getTurnOfId(), -1);
    if (isMyTurn()) {
      // allow the player to select his game move (row&col to place his marker)
    }
  }  
  private function performMove(gameMove:GameMove):void
  {
    var isHit:Boolean;
    //check if the player hit your ship
    var gameData:GameData=new GameData();
    gameData.isHit = isHit;
    gameData.column = gameMove.column;
    gameData.row = gameMove.row;
    gameData.playerAttacking = gameMove.playerAttacking;
    gameData.playerIdAttacked = gameMove.playerIdAttacked;
    
    doStoreState([UserEntry.create(gameMove.objectKey(),gameData,false)]);
    updateHits(gameData);
  }
  private function updateHits(gameData:GameData):void
  {
  	if(gameData.isHit)
	{
		//make graphic hit
		var isGameOver:Boolean;
		//check if game is over
		if (isGameOver) {
			var shipStatesToReveal:Array=[];
			for each(var playerId:int in allPlayerIds)
			  shipStatesToReveal.push(RevealEntry.create("ships_"+playerId,allPlayerIds));
			doAllRevealState(shipStatesToReveal);
		}
  	}
  	else
  	{
  	  //make graphic miss
  	  turnNumber ++; // advance the turn
  	  doAllSetTurn(getTurnOfId(), -1);
  	}
  	if (isMyTurn()) {
      // allow the player to select his game move (row&col to place his marker)
    }
  }
  public function userMadeHisMove(gameMove:GameMove):void {
    doStoreState([ UserEntry.create(gameMove.objectKey(), gameMove, false) ]);
    //performMove(gameMove);
  }
  public function userSetHisBoard(allShips:Array):void
  {
  	doStoreState([UserEntry.create("ships_"+myUserId,allShips,true)]);
  	shipStatesCommited++;
  	if(shipStatesCommited == allPlayerIds.length)
  		startMove();
  }
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    // allow user to arrange his board 
    shipStatesCommited = 0;
    turnNumber = 0;
  }
  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    if (entry.storedByUserId == myUserId) return; // user move is not relevent
    if(shipStatesCommited != allPlayerIds.length)
    {
	  require(entry.visibleToUserIds.length ==1);
      require(entry.visibleToUserIds[0] == entry.storedByUserId);
      require(entry.key == "ships_"+entry.storedByUserId);
      shipStatesCommited++;
      if(shipStatesCommited == allPlayerIds.length)
  		startMove();	
    }
    else
    {
    	require(entry.visibleToUserIds == null);
    	var value:Object=SerializableClass.deserialize(entry.value);
    	if(value is ShipData)
    	{
    		require(entry.key == ("ships_"+entry.storedByUserId));
    		var hackerId:int;
  	      	//check if all the moves the players have made correspond to the cubes array
  	      	//if so hackerId= -1 else hackerId = hacker id
    	 	 if(hackerId != -1)
    	 	 {
    	  		doAllFoundHacker(hackerId,"rival answers dont correspond with secret state");
    	 	 }
    	  	 else
    	  	 {
    	     	var finishedPlayers:Array/*PlayerMatchOver*/ = [];
			 	for each (var playerId:int in allPlayerIds) 
			 	{
					var score:int, potPercentage:int;
					// set the score and potPercentage for playerId
					finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
				}
			 doAllEndMatch(finishedPlayers);
    	     }
		 }
		 else if(value is GameMove)
		 {
			var gameMove:GameMove =value as GameMove;
			require(entry.storedByUserId == getTurnOfId());
			require(entry.storedByUserId == gameMove.playerAttacking);
			performMove(gameMove); 
		 }
		 else if(value is GameData)
		 {
			var gameData:GameData =value as GameData;
			require(verifyGameData(gameData));
			updateHits(gameData);	
		 }
    }
  }
}

}
import come2play_as3.api.auto_copied.*;
	
class GameData extends SerializableClass{
  public var row:int, column:int,playerIdAttacked:int,isHit:Boolean,playerAttacking:int;
}
class GameMove extends SerializableClass{
  public var row:int, column:int,playerIdAttacked:int,playerAttacking:int;
  public function objectKey():String
  {
  	return playerIdAttacked+"_"+row+"_"+column;
  }
  public function testKey(gameMoveTarget:Array):Boolean
  {
  	return ((gameMoveTarget[0] == playerIdAttacked) && (gameMoveTarget[1] == row) && (gameMoveTarget[2] == column))
  }   
}
class ShipData extends SerializableClass{
  public var ships:Array/*Ship*/;
}
class Ship extends SerializableClass{
  public var row:int, column:int,length:int,vertical:Boolean;
}