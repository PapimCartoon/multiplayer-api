package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	/*****************************************
	 * The keys in the Match state:
	 * The calculators store in secret memory:
	 * <row>_<column>:GameBrick
	 * Each brick that is revealed by the players
	 * runs over the GameBricks the calculator has stored
	 * 
	 * <playerId>_<row>_<column>: GameMove
	 * holds the moves each player has performed and were
	 * not yet committed to the game state memory the
	 * calculator has stored
	 * 
	 *****************************************/
	public class PseudoMineSweeper extends SimplifiedClientGameAPI
	{
		public static var mineAmount:int=20;
		public static var boardSize:int=25;


	override public function gotRequestStateCalculation(requestId:int,serverEntries:Array):void
	{ 
		var serverEntry:ServerEntry=serverEntries[0];
		var newBoardEntries:Array/*ServerEntry*/=new Array();
		/*
		This function runs on a player not playing in the current game
		it gets a random seed and stores an array of server entries 
		each containing a game brick with either a mine or the amount
		of mines it is touching each serverEntry key will be built from
		row_column
		*/
		doAllStoreStateCalculation(requestId,newBoardEntries)
	}
	override public function gotMatchStarted2():void 
	{
		// init the logic and the graphics
		doAllRequestRandomState("randomSeed",true);
		doAllRequestStateCalculation(["randomSeed"]);
	}
  public function performMove(gameMove:GameMove):void {
    var isBrickFree:Boolean;
    /*
     check if the brick the player wanted to play on
     wasn't already caught by the other player
     remember there can be a case were 2 users press almost simultaneously
     and then the user which pressed first gets the square
    */
    if(isBrickFree)
    {
    	//mark the brick as occupied
    	doAllRevealState([RevealEntry.create(gameMove.row+"_"+gameMove.column,null)])	
    }
  }
  public function verifyBrick(revealedBrick:RevealedBrick):Boolean
  {
  	var value:Object;
  	var tempBrick:GameBrick;
  	for each(var serverEntry:ServerEntry in state)
  	{
  		value = SerializableClass.deserialize(serverEntry.value);
  		if(value is GameBrick)
  		{
  			tempBrick=value as GameBrick;
  			if((tempBrick.col == revealedBrick.brick.col) &&
  			  (tempBrick.row == revealedBrick.brick.row)) 
  			  	{
  			  		return ((tempBrick.isMine == revealedBrick.brick.isMine) &&
  			  				(serverEntry.storedByUserId == revealedBrick.player ));
  			  	}
  		}		
  	} 
  	return false;
  }
  public function findPlayer(gameBrick:GameBrick):GameMove
  {
  	var gameMove:GameMove
  	var value:Object
  	for each(var serverEntry:ServerEntry in state)
  	{
  		value = SerializableClass.deserialize(serverEntry.value);
  		if(value is GameMove)
  		{
  			gameMove = value as GameMove;
  			if( (gameBrick.col == gameMove.column) && (gameBrick.row == gameMove.row))
  			{
  				return gameMove;
  			}
  		}
  	}
  	return null;
  }
   public function updateBoard(gameBrick:GameBrick,gameMove:GameMove):void
   {
   	var revealedBrick:RevealedBrick=new RevealedBrick();
   	revealedBrick.brick = gameBrick;
   	revealedBrick.player = gameMove.playerId;
   	//update graphics for mine
   	if(myUserId == gameMove.playerId)
   	{
   		doStoreState([UserEntry.create(gameMove.getKey(),null,false),
   					  UserEntry.create(gameMove.row+"_"+gameMove.column,revealedBrick,false)])
   	}
   	 var isGameOver:Boolean;
    //checks if the game is over,meaning all the board was cleared
    if (isGameOver) {
		var finishedPlayers:Array/*PlayerMatchOver*/ = []; 
    	for each (var playerId:int in allPlayerIds) {
    		var score:int, potPercentage:int;
        	//set the score and potPercentage for playerId
    		finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
     	}
     	doAllEndMatch(finishedPlayers);
   	}
   }
  public function userMadeMove(gameMove:GameMove):void {
    doStoreState([ UserEntry.create(gameMove.getKey(), gameMove, false) ]);
  }
  

  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	var entry:ServerEntry = serverEntries[0];
    if (entry.key == "randomSeed") return;//players don't need the secret mine position seed
    if(serverEntries.length == boardSize*boardSize)
    {
    	if(entry.storedByUserId == -1)
    	{
    	//allow players to start playing
    	}
    	else
    	{
    	doAllFoundHacker(entry.storedByUserId,"a user stored the game board instead of a calculator");
    	}
    }
    	var gameMove:GameMove;
    	var value:Object=SerializableClass.deserialize(entry.value);
    	if(value is GameMove )
    	{
			gameMove=value as GameMove;
			require(gameMove.playerId == entry.storedByUserId);
			performMove(gameMove);
    	}
    	else if(value is GameBrick )
    	{
    		var gameBrick:GameBrick=value as GameBrick;
    		require(entry.storedByUserId == -1);
    		gameMove=findPlayer(gameBrick);
    		updateBoard(gameBrick,gameMove)
    	}
    	else if(value is RevealedBrick )
    	{
    		var revealedBrick:RevealedBrick = value as RevealedBrick;
    		require(revealedBrick.player == entry.storedByUserId);
    		require(verifyBrick(revealedBrick));
    	}

    }
    
 }
}
import come2play_as3.api.auto_copied.*;
	
class GameMove extends SerializableClass {
  public var row:int, column:int,playerId:int,className:String;

  public function getKey():String
  {
  	return playerId+"_"+row+"_"+column;
  }
   
}
class RevealedBrick extends SerializableClass{
	public var brick:GameBrick,player:int;
 
}
class GameBrick extends SerializableClass{
  public var isMine:Boolean, touchingMines:int,row:int,col:int;
    
}