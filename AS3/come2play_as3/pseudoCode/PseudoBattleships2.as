package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	/*****************************************
	 * The keys in the Match state:
	 * The calculators store in secret memory:
	 * "board"_<playerId>_<row>_<column> : GameBrick
	 * built from the secret ship positions the players have entered
	 * by the calculator, later will be over run by other player guesses
	 * on the player ship positions 
	 * 
	 * "player"_<playerId>_<row>_<column>: GameMove
	 * holds the moves each player has performed and were not checked 
	 * 
	 *****************************************/	
public class PseudoBattleships2 extends SimplifiedClientGameAPI {
  public var turnNumber:int;
  public var shipStatesCommited:int;
  public static var boardSize:int=20;
  
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
  private function findMatchingGameMove(gameBrick:GameBrick):GameMove
  {
  	  	var value:Object;
  	var gameMove:GameMove
  	for each(var serverEntry:ServerEntry in state)
  	{
  		value = SerializableClass.deserialize(serverEntry.value);
  		if(value is GameMove)
  		{
  			gameMove=value as GameMove;
			if( (gameMove.column == gameBrick.column) &&
				(gameMove.row == gameBrick.row) )
					return gameMove;
  		}
  	}
  	
  	return null;
  }
  private function startMove():void {
    doAllSetTurn(getTurnOfId(), -1);
    if (isMyTurn()) {
      // allow the player to select his game move (row&col to place his marker)
    }
  }  
   private function startGame():void {
	var shipSecretPositionKeys:Array=new Array();
	for each(var playerId:int in allPlayerIds)
	{
		shipSecretPositionKeys.push("ships_"+playerId);
	}
	doAllRequestStateCalculation(shipSecretPositionKeys);
  } 
  private function performMove(gameBrick:GameBrick):void
  {
  	var gameMove:GameMove=findMatchingGameMove(gameBrick);
  	require(gameMove != null);
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
  		startGame();
  }
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    // allow user to arrange his board 
    shipStatesCommited = 0;
    turnNumber = 0;
  }
  override public function gotRequestStateCalculation(requestId:int,serverEntries:Array):void
  {
  	var newBoardEntries:Array;
  	//gets the secret array of ships, checks if its legal
  	//if so extrapolate a board and stores it
  	doAllStoreStateCalculation(requestId,newBoardEntries);
  }
  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    if (entry.storedByUserId == myUserId) return; // user move is not relevant
    if(shipStatesCommited != allPlayerIds.length)
    {
	  require(entry.visibleToUserIds.length ==1);
      require(entry.visibleToUserIds[0] == entry.storedByUserId);
      require(entry.key == "ships_"+entry.storedByUserId);
      shipStatesCommited++;
      if(shipStatesCommited == allPlayerIds.length)
  		startGame();	
    }
    else
    {
    	require(entry.visibleToUserIds == null);
    	var value:Object=SerializableClass.deserialize(entry.value);
    	if(serverEntries.length == (boardSize*boardSize*allPlayerIds.length))
    	{
    		require(entry.storedByUserId == -1);
    		startMove();	
    	}
		else if(value is GameMove)
		{
			var gameMove:GameMove =value as GameMove;
			require(entry.storedByUserId == getTurnOfId());
			require(entry.storedByUserId == gameMove.playerAttacking);
			doAllRevealState([RevealEntry.create("board_"+gameMove.objectKey(),null)])
			
		}
		else if(value is GameBrick)
		{
			var gameBrick:GameBrick =value as GameBrick;
			require(entry.storedByUserId == -1);
			performMove(gameBrick); 
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
class GameBrick extends SerializableClass{
	public var row:int, column:int,isShip:Boolean;
}
class ShipData extends SerializableClass{
  public var ships:Array/*Ship*/;
}
class Ship extends SerializableClass{
  public var row:int, column:int,length:int,vertical:Boolean;
}