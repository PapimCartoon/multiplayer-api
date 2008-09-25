package come2play_as3.pseudoCode.battleShips
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.pseudoCode.SimplifiedClientGameAPI;
	/*****************************************
	 * The keys in the Match state:
	 * The calculators store in secret memory:
	 * {type:"board",playerId:<playerId>,row:<row>,column:<column>} : GameBrick
	 * built from the secret ship positions the players have entered
	 * by the calculator, later will be over run by other player guesses
	 * on the player ship positions 
	 * 
	 * {type:"player",playerId:<playerId>,row:<row>,column:<column>}: GameMove
	 * holds the moves each player has performed and were not checked 
	 * 
	 *****************************************/	
public class PseudoBattleships extends SimplifiedClientGameAPI {
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
  	var gameMove:GameMove
  	for each(var serverEntry:ServerEntry in state)
  	{
  		if(serverEntry.value is GameMove)
  		{
  			gameMove=serverEntry.value as GameMove;
  			if( (gameMove.column ==gameData.column) &&
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
  	var gameMove:GameMove
  	for each(var serverEntry:ServerEntry in state)
  	{
  		if(serverEntry.value is GameMove)
  		{
  			gameMove=serverEntry.value as GameMove;
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
		shipSecretPositionKeys.push({type:"ships",playerId:playerId});
	}
	doAllRequestStateCalculation(shipSecretPositionKeys);
  } 
  private function performMove(gameBrick:GameBrick):void
  {
  	var gameMove:GameMove=findMatchingGameMove(gameBrick);
  	require(gameMove != null);
    var isHit:Boolean;
    //check if the player hit your ship
    var gameData:GameData= GameData.create(gameMove.row,gameMove.column,gameMove.playerIdAttacked ,isHit,gameMove.playerAttacking)
    doStoreState([UserEntry.create(gameMove.objectKey(),gameData,false)]);
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
			  shipStatesToReveal.push(RevealEntry.create({type:"ships",playerId:playerId},allPlayerIds));
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
  }
  public function userSetHisBoard(allShips:Array):void
  {
  	doStoreState([UserEntry.create({type:"ships",palyerId:myUserId},allShips,true)]);
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
    var serverEntry:ServerEntry = serverEntries[0];
    if (serverEntry.storedByUserId == myUserId) return; // user move is not relevant
    if(shipStatesCommited != allPlayerIds.length)
    {
	  require(serverEntry.visibleToUserIds.length ==1);
      require(serverEntry.visibleToUserIds[0] == serverEntry.storedByUserId);
      require(serverEntry.key.type == "ships")
      require(serverEntry.key.playerId == serverEntry.storedByUserId);
      shipStatesCommited++;
      if(shipStatesCommited == allPlayerIds.length)
  		startGame();	
    }
    else
    {
    	require(serverEntry.visibleToUserIds == null);
    	if(serverEntries.length == (boardSize*boardSize*allPlayerIds.length))
    	{
    		require(serverEntry.storedByUserId == -1);
    		startMove();	
    	}
		else if(serverEntry.value is GameMove)
		{
			var gameMove:GameMove =serverEntry.value as GameMove;
			require(serverEntry.storedByUserId == getTurnOfId());
			require(serverEntry.storedByUserId == gameMove.playerAttacking);
			doAllRevealState([RevealEntry.create(gameMove.objectKey(),null)])
			
		}
		else if(serverEntry.value is GameBrick)
		{
			var gameBrick:GameBrick =serverEntry.value as GameBrick;
			require(serverEntry.storedByUserId == -1);
			performMove(gameBrick); 
		}
	    else if(serverEntry.value is GameData)
		{
			var gameData:GameData = serverEntry.value as GameData;
			require(verifyGameData(gameData));
			updateHits(gameData);	
		}
    }
  }
}

}

