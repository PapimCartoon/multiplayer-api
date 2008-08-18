package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	public class PseduMineSweeper extends SimplifiedClientGameAPI
	{
		public static var mineAmount:int=20;
		public static var boardSize:int=25;


	override public function gotRequestStateCalculation(serverEntries:Array):void
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
		doAllStoreStateCalculation(newBoardEntries)
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
    	doAllRevealState([new RevealEntry(gameMove.row+"_"+gameMove.column,null)])	
    }
  }
  public function verifyBrick(revealedBrick:RevealedBrick):Boolean
  {
  	for each(var serverEntry:ServerEntry in state)
  	{
  		if(serverEntry.value.className == "GameBrick")
  		{
  			var tempBrick:GameBrick=GameBrick.object2GameBrick(serverEntry.value);
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
  	for each(var serverEntry:ServerEntry in state)
  	{
  		var gameMove:GameMove = GameMove.object2GameMove(serverEntry.value);
  		if( (gameBrick.col == gameMove.column) && (gameBrick.row == gameMove.row))
  		{
  			return gameMove;
  		}
  	}
  	return null;
  }
   public function updateBoard(gameBrick:GameBrick,gameMove:GameMove):void
   {
   	var revealedBrick:RevealedBrick=new RevealedBrick(gameBrick,gameMove.playerId);
   	//update graphics for mine
   	if(myUserId == gameMove.playerId)
   	{
   		doStoreState([new UserEntry(gameMove.getKey(),null,false),
   					  new UserEntry(gameMove.row+"_"+gameMove.column,revealedBrick,false)])
   	}
   	 var isGameOver:Boolean;
    //checks if the game is over,meaning all the board was cleared
    if (isGameOver) {
		var finishedPlayers:Array/*PlayerMatchOver*/ = []; 
    	for each (var playerId:int in allPlayerIds) {
    		var score:int, potPercentage:int;
        	//set the score and potPercentage for playerId
    		finishedPlayers.push( new PlayerMatchOver(playerId, score, potPercentage) );
     	}
     	doAllEndMatch(finishedPlayers);
   	}
   }
  public function userMadeMove(gameMove:GameMove):void {
    doStoreState([ new UserEntry(gameMove.getKey(), gameMove, false) ]);
  }
  

  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	var entry:ServerEntry = serverEntries[0];
    if (entry.key == "randomSeed") return;//players don't need the secret mine position seed
    if (entry.value == null) return ;
    
    	var gameMove:GameMove;
    	if(entry.value.className == "GameMove" )
    	{
			gameMove=GameMove.object2GameMove(entry.value);
			performMove(gameMove);
    	}
    	else if(entry.value.className == "GameBrick" )
    	{
    		var gameBrick:GameBrick=GameBrick.object2GameBrick(entry.value);
    		if(entry.storedByUserId == -1)
    		{
    			//allow players to start playing
    		}
    		else
    		{
    		gameMove=findPlayer(gameBrick);
    		updateBoard(gameBrick,gameMove)
    		}
    	}
    	else if(entry.value.className == "RevealedBrick" )
    	{
    		var revealedBrick:RevealedBrick = RevealedBrick.object2RevealedBrick(entry.value);
    		require(verifyBrick(revealedBrick));
    	}

    }
    
 }
}
class GameMove {
  public var row:int, column:int,playerId:int,className:String;
  function GameMove(row:int, column:int,playerId:int) {
    this.row = row;
    this.column = column;
    this.playerId = playerId;
    this.className = "GameMove";
  }
  public function getKey():String
  {
  	return playerId+"_"+row+"_"+column;
  }
  public static function object2GameMove(obj:Object):GameMove {
    return new GameMove(obj["row"], obj["column"],obj["playerId"]);
  }     
}
class RevealedBrick{
	public var brick:GameBrick,player:int,className:String;
	function RevealedBrick(brick:GameBrick, player:int) {
    	this.brick= brick;
    	this.player = player;
    	this.className = "RevealedBrick"
	}
  	public static function object2RevealedBrick(obj:Object):RevealedBrick{
    	return new RevealedBrick(GameBrick.object2GameBrick(obj["brick"]), obj["player"]);
  	}  
}
class GameBrick {
  public var isMine:Boolean, touchingMines:int,row:int,col:int,className:String;
  function GameBrick(isMine:Boolean,touchingMines:int,row:int,col:int) {
    this.isMine = isMine;
    this.touchingMines = touchingMines;
    this.row = row;
    this.col = col;
    this.className = "GameBrick"
  }
  	
  public static function object2GameBrick(obj:Object):GameBrick{
    return new GameBrick(obj["isMine"], obj["touchingMines"],obj["row"], obj["col"]);
  }     
}