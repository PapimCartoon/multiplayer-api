package come2play_as3.pseudoCode.backgammon
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.pseudoCode.SimplifiedClientGameAPI;
	/*****************************************
	 * The keys in the Match state:
	 * 
	 * the current positions on the board
	 * <i> : GamePlace
	 * 
	 * {type = "gameMove" num=<i>} : GameMove
	 * the last move committed 
	 *****************************************/	
	public class PseudoBackgammon extends SimplifiedClientGameAPI {
	  	public var turnNumber:int;
	  	public var isDicePhase:Boolean;
	  
	  	private function getTurnOfId():int {
			return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
	  	}
	  	private function isMyTurn():Boolean {
	    	return getTurnOfId()==myUserId;
	  	}
	  	private function gameMove2UserEntry(gameMove:GameMove):Array/*userEntry*/
	  	{
	  		var userEntries:Array/*userEntry*/
	  		//A function that takes a GameMove object and extrapolates the changes to the game state
	  		//key will be the place on the Backgammon board.
	  		//value will be a GamePlace object
	  		return userEntries;
	  	}
	      	
	  	private function startMove(randomSeed:int):void {
	    	doAllSetTurn(getTurnOfId(), -1);
	    	if (isMyTurn()) {
	    		var dice:Dice=new Dice(randomSeed);
				var isAbleToMove:Boolean;// check if the player has a valid move
				if(isAbleToMove)
				{
					// allow the player to select his game moves (game pieces current location and new location)
	  			}
	  			else
	  			{
	  				var gameMove:GameMove=new GameMove()
	  				gameMove.pieceCurrentLocation = -1;
	  				gameMove.pieceNewLocation = -1;
	  				doStoreState([UserEntry.create("gameMove_0",gameMove,false)]);	
	  			}
	    	}
	  	}  
	  	private function startTurn():void
	  	{
	  		isDicePhase=true;
	  		doAllRequestRandomState("randomSeed",false);
	  	}
	  	private function performMove(gameMoves:Array/*GameMove*/):void {
	    	// update the logic and the graphics
	    	turnNumber ++; // advance the turn
	    	var isGameOver:Boolean;
	    	// check if the game is over
	    	if (!isGameOver) {
	      		startTurn();
	    	} else {
	      		var finishedPlayers:Array/*PlayerMatchOver*/ = [];
	      		for each (var playerId:int in allPlayerIds) {
	        		var score:int, potPercentage:int;
	        	// set the score and potPercentage for playerId
	        	finishedPlayers.push(PlayerMatchOver.create(playerId, score, potPercentage) );
	      		}
	      		doAllEndMatch(finishedPlayers);
	    	}
	  	}
	  	public function userMadeHisMove(gameMoves:Array/*GameMove*/):void {
	  		var userEntries:Array/*UserEntry*/ = [];
	    	for(var i:int=0;i<gameMoves.length;i++)
	    	{
	     		var gameMove:GameMove = gameMoves[i];
	     		var keyObj:Object ={type:"gameMove",num:i}
	      		userEntries.push(UserEntry.create(keyObj,gameMove,false) );
	      		userEntries.concat(gameMove2UserEntry(gameMove));  
	    	}
	    	doStoreState(userEntries);
	  	}
	  
	  	override public function gotMatchStarted2():void {
	    	// init the logic and the graphics
	    	turnNumber = 0;
	    	startTurn();
	  	}
	  	override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	    	
	    	var serverEntry:ServerEntry = serverEntries[0];
	    	
	    	if(serverEntry.key == "randomSeed")
	    	{
	    		require(serverEntry.storedByUserId == -1);
	    		isDicePhase=false;
	    		startMove(serverEntry.value as int);	
	    	}
	    	else if(serverEntry.value is GameMove)
	    	{
	    		var gameMoves:Array=new Array();
	    		for(var i:int=0;i<serverEntries.length;i+=3)
	      		{
	      			serverEntry=serverEntries[i];
	      			require(serverEntry.key.type=="gameMove");
	      			require(serverEntry.key.num==i);
	      			serverEntry = serverEntries[i]
	      			var gameMove:GameMove = serverEntry.value as GameMove
	      			var myGameMoveCalculation:Array=gameMove2UserEntry(gameMove);
	        		var rivalGameMoveCalculation:Array=[serverEntries[i+1],serverEntries[i+2]];
	      			
	      			var compareStateChanges:Boolean;
	      			//checks if the moves performed by the other player correspond 
	      			//to the changes the other player wants to do to the game state
	        		require(compareStateChanges);
	        		
	        		gameMoves.push(gameMove);        		
	      		}	
	      		performMove(gameMoves);  
	    	}
	  	} 
	  	
	  	
	}
}

class Dice {
	public var die1:int, die2:int;
	function Dice(seed:Number)
	{
		var randomSeed:int = seed % 36;
		die1 = randomSeed / 6;
		die2 = randomSeed % 6;
	}
}