package come2play_as3.pseudoCode.domino
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.pseudoCode.SimplifiedClientGameAPI;
	/*********************************
	 * The keys in the Match state:	
	 *							
	 * The shuffeled Dominoes
	 * 	{type:"domino",num:<i>}:DominoCube
	 * 
	 * The player moves
	 * 	{num:<i>}:GameMove
	 ********************************/
	public class PseudoDominoes extends SimplifiedClientGameAPI
    {
	  	public var turnNumber:int;
	 	public var cubesDrawn:int;
	  	public static var cubeMax:int = 28;
	  	public function PseudoDominoes()
	  	{
	  		(new GameMove).register();
	  		(new DominoCube).register();
	  	}
	  	private function getTurnOfId():int {
	    	return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
	 	}
	  	private function getEntryKey():Object {
	    	return {num:turnNumber};
	  	}
	  	private function isMyTurn():Boolean {
	    	return getTurnOfId()==myUserId;
	  	}
	  
	  	private function startMove():void {
	    	doAllSetTurn(getTurnOfId(), -1);
	    	if (isMyTurn()) {
	      		// allow the player to select his game move (draw or put a domino brick)
	    	}
	  	}  
	  	private function performMove(gameMove:GameMove):void {
	  	 	if(gameMove.isTakingCube)
	  	 	{
	  	 		if(cubesDrawn < cubeMax)
	  	 			doAllRevealState([RevealEntry.create({type:"domino",num:cubesDrawn},[getTurnOfId()])]);
	  	 		else
	  	 		{
	  	 	  		turnNumber ++; // advance the turn
	  	 	  		isEndGame();	
	  	 		}
	  	 	}
	  	 	else
	  	 	{
	  	 		// update the logic and the graphics for putting a cube	
	  	 		turnNumber ++; // advance the turn
	  	 		isEndGame();
	  	 	}
	  	}
	  	private function drawCube(dominoCube:DominoCube):void
	  	{
	  		if(isMyTurn())
	  		{
	  			//add dominoCube to the user's cubes
	  		}
	  		cubesDrawn++;
	  		turnNumber ++; // advance the turn
	  		startMove();
	  	}
	  	private function isEndGame():void
	  	{
	  		
	  		var isGameOver:Boolean;
	    	//checks if the game is over
	    	if (!isGameOver) {
	      		startMove();
	    	} else {
				var revealCubes:Array=new Array();
				for(var i:int=0;i<cubeMax;i++)
					revealCubes.push(RevealEntry.create({type:"domino",num:i},allPlayerIds));	
				doAllRevealState(revealCubes);
	    	}
	  	}
	  	private function endGame(allDominoCubes:Array/*DominoCube*/):void
	  	{
	  		var hackerId:int;
	  		//check if all the moves the players have made correspond to the cubes array
	  		//if so hackerId= -1 else hackerId = hacker id
	  		if(hackerId != -1)
	  		{
	   		doAllFoundHacker(hackerId,"user: "+hackerId+" made moves that are not legal with the game deck");
	    	}
	    	else
	  		{
	  	   		var finishedPlayers:Array/*PlayerMatchOver*/ = [];
	      		for each (var playerId:int in allPlayerIds) {
	        	var score:int, potPercentage:int;
	        	// set the score and potPercentage for playerId
	        	finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
	      		}
	      	doAllEndMatch(finishedPlayers);
	   		}
	  	}
	  	private function compareDominoArrays(myDominoDeck:Array/*userEntry*/,rivalDominoDeck:Array/*ServerEntry*/):Boolean
	  	{
	  		if(myDominoDeck.length != rivalDominoDeck.length)
	  			return false;
	  		var myEntry:UserEntry;
	  		var rivalEntry:ServerEntry;
	  		for(var i:int=0;i<myDominoDeck.length;i++)
	  		{
	  			myEntry=myDominoDeck[i];
	  			rivalEntry=rivalDominoDeck[i];
	  			if( (myEntry.key != rivalEntry.key ) || 
	  				(rivalEntry.visibleToUserIds == null) ||
	  				(myEntry.value.upperNumber != rivalEntry.value.upperNumber ) ||
	  				(myEntry.value.lowerNumber != rivalEntry.value.lowerNumber ) )
	  				return false;
	  		}
	  	return true;
	  	}
	  	public function userMadeHisMove(gameMove:GameMove):void {
	     	doStoreState([UserEntry.create(getEntryKey(), gameMove, false)]);
	  	}
	  	private function placeDominos():Array/*UserEnry*/
	  	{
	  		//fills an array with UserEntries consisting of all the dominoes neede for a game
	  		return [];
	  	}
	  	override public function gotMatchStarted2():void {
	    	// init the logic and the graphics
	    	turnNumber = 0;
	    	cubesDrawn = 0;
	    	if (isMyTurn()) {
	      		var dominoCubes:Array=placeDominos();
	      		var dominoCubesKeys:Array=new Array();
	      		for each(var cubeUserEntry:UserEntry in dominoCubes)
	        		dominoCubesKeys.push(cubeUserEntry.key);
	      		doStoreState(dominoCubes);
	      		doAllShuffleState(dominoCubesKeys);
	    	}
	  	}
	  	override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	    	//require(serverEntries.length==1);
	    	var serverEntry:ServerEntry = serverEntries[0];
	    	if(serverEntries.length == cubeMax)
	    	{
	    		if(serverEntry.storedByUserId == -1)
	    		{
	    			if(serverEntry.visibleToUserIds.length == 0)
	    			{
	    			//ignore the shuffled keys return
	    			}
	    			else
	    			{
						var allDominoCubes:Array=new Array();
						for each(var tempServerEntry:ServerEntry in serverEntries)
							allDominoCubes.push(serverEntry.value as DominoCube);
						endGame(allDominoCubes);	
	    			}
	    		}
	    		else
	    		{
	    			var myDominoDeck:Array=placeDominos();
	    			var rivalDominoDeck:Array=serverEntries;
	    			require(compareDominoArrays(myDominoDeck/*userEntry*/,rivalDominoDeck/*ServerEntry*/));
	    			
	    			//after checking there was no foul play,shuffle keys
	    			var dominoCubesKeys:Array = new Array();
	      			for each(var cubeUserEntry:UserEntry in myDominoDeck)
	        			dominoCubesKeys.push(cubeUserEntry.key);
	      			doAllShuffleState(dominoCubesKeys);	
	      			
	      			//after shuffelling the dominoes,draw 7 for each player
	      			var revealKeys:Array=new Array();
	    			for(var i:int=0;i<allPlayerIds.length;i++)
	    	  			for(var j:int=0;j<7;j++)
	    	    			revealKeys.push(RevealEntry.create("domino_"+(i*7+j),[allPlayerIds[i]]))
	    			doAllRevealState(revealKeys);
	    		}
	    	}
	    	else if(serverEntries.length == (allPlayerIds.length*7))
			{
	    		for each(serverEntry in serverEntries)
	    		{
	    	  		require(serverEntry.storedByUserId == -1);
	    	  		if(serverEntry.visibleToUserIds[0]==myUserId)
	    	  		{
	    	  			var value:DominoCube = serverEntry.value as DominoCube;
	    	  			//add Domino to your board graphically
	    	  		}
	    	  		else
	    	  		{
	    	  			//add hidden domino to serverEntry.visibleToUserIds[0] board
	    	  		}
	    	  		cubesDrawn++;
	    		}
	    		//take the 7 dominoes 
	    		startMove();	
			}
	    	else if(serverEntry.value is GameMove)
	    	{
	    		var gameMove:GameMove = serverEntry.value as GameMove;
	    		require(serverEntry.visibleToUserIds == null);
	    		require(serverEntry.key == getEntryKey());
	    		require(serverEntry.storedByUserId == getTurnOfId());
	    		performMove(gameMove);
	    	}
	    	else if(serverEntry.value is DominoCube)
	    	{
	    		var dominoCube:DominoCube = serverEntry.value as DominoCube;
	    		require(serverEntry.storedByUserId == -1); 		
				drawCube(dominoCube);
	    	}
	  	} 
	}
}


