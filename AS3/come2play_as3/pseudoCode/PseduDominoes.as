package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	public class PseduDominoes extends SimplifiedClientGameAPI
    {
  public var turnNumber:int;
  public var gamePhase:int;
  public var cubeCount:int;
  public static var cubeMax:int = 28;
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
      // allow the player to select his game move (draw or put a domino brick)
    }
  }  
  public function performMove(gameMove:DominoCube):void {
  	 if(gameMove.isTakingCube)
  	 {
  	 	if(cubeCount < cubeMax)
  	 		doAllRevealState([new RevealEntry(String(cubeCount),[myUserId])]);
  	 	else
  	 	{
  	 	  turnNumber ++; // advance the turn
  	 	  isEndGame();	
  	 	}
  	 }
  	 else
  	 {
  	 // update the logic and the graphics for puting a cube	
  	 turnNumber ++; // advance the turn
  	 isEndGame();
  	 }
  	 gamePhase=4
  }
  public function drawCube(dominoCube:DominoCube):void
  {
  	if(isMyTurn())
  	{
  	//add dominoCube to the user's cubes
  	}
  	cubeCount++;
  	turnNumber ++; // advance the turn
  	startMove();
  	gamePhase=3;
  }
  public function isEndGame():void
  {
  	gamePhase=5;
  	 var isGameOver:Boolean;
    //checks if the game is over
    if (!isGameOver) {
      startMove();
    } else {
		var revealCubes:Array=new Array();
		for(var i:int=0;i<cubeMax;i++)
		{
		revealCubes.push(new RevealEntry(String(i),allPlayerIds));	
		}
		doAllRevealState(revealCubes);
    }
  }
  public function engGame(allDominoCubes:Array/*DominoCube*/):void
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
        finishedPlayers.push( new PlayerMatchOver(playerId, score, potPercentage) );
      }
      doAllEndMatch(finishedPlayers);
   }
   

  }
  public function compareServerEntryArrays(arr1:Array,arr2:Array):Boolean
  {
  	var UserEntry1:ServerEntry;
  	var UserEntry2:ServerEntry;
  	for(var i:int=0;i<arr1.length;i++)
  	{
  		UserEntry1=arr1[i];
  		UserEntry2=arr2[i];
  		if((UserEntry1.key != UserEntry2.key ) || 
  		(UserEntry1.authorizedUserIds != UserEntry2.authorizedUserIds ) ||
  		(UserEntry1.value.upperNumber != UserEntry2.value.upperNumber ) ||
  		(UserEntry1.value.lowerNumber != UserEntry2.value.lowerNumber ) )
  			return false;
  	}
  	return true;
  }
  public function userMadeHisMove(dominoCube:DominoCube):void {
     doStoreState([new UserEntry(getEntryKey(), dominoCube, false)]);
     performMove(dominoCube);
  }
  private function placeDominos():Array/*UserEnry*/
  {
  	//fills an array with UserEntries consisting of all the dominoes neede for a game
  	return [];
  }
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    turnNumber = 0;
    gamePhase = 0;
    cubeCount = 0;
    if (isMyTurn()) {
      var dominoCubes:Array=placeDominos();
      var dominoCubesKeys:Array=new Array();
      for each(var cubeUserEntry:UserEntry in dominoCubes)
        dominoCubesKeys.push(cubeUserEntry.key);
      doStoreState(dominoCubes);
      doAllShuffleState(dominoCubesKeys);
    }
  }
  override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
    //require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    var dominoCube:DominoCube;
    if (entry.storedByUserId == myUserId) return; 
    if(gamePhase == 0)
    {
      for each(var tempEntry:ServerEntry in serverEntries)
      	require(tempEntry.authorizedUserIds == null);
      var myDominoDeck:Array=placeDominos();
      var rivalDominoDeck:Array=serverEntries;
      require(myDominoDeck.length==rivalDominoDeck.length);
      require(compareServerEntryArrays(myDominoDeck,rivalDominoDeck));
      var dominoCubesKeys:Array = new Array();
      for each(var cubeUserEntry:UserEntry in myDominoDeck)
        dominoCubesKeys.push(cubeUserEntry.key);
      doAllShuffleState(dominoCubesKeys);
      gamePhase = 1;
    }
    else if(gamePhase == 1)
    {
    	var revealKeys:Array=new Array();
    	for(var i:int=0;i<allPlayerIds.length;i++)
    	  for(var j:int=0;j<7;j++)
    	  {
    	    revealKeys.push(new RevealEntry(String(i*7+j),[allPlayerIds[i]]))
    	  }
    	doAllRevealState(revealKeys);
    	gamePhase = 2;
    	//startMove();
    }
    else if(gamePhase == 2)
    {
    	require(serverEntries.length == (allPlayerIds.length*7));
    	for each(var serverEntry:ServerEntry in serverEntries)
    	{
    	  require(serverEntry.storedByUserId == -1);
    	  if(serverEntry.authorizedUserIds[0] == myUserId)
    	  	{
    	  		//add Domino to your board graphicly
    	  	}
    	  	cubeCount++;
    	}
    	//take the 7 dominoes 
    	gamePhase = 3;
    	startMove();
    }
    else if(gamePhase == 3)
    {
      require(entry.authorizedUserIds == null);
      require(entry.key == getEntryKey());
      require(entry.storedByUserId == getTurnOfId());
      require(entry.value is DominoCube);
      dominoCube=DominoCube.object2DominoCube(entry.value);
	  performMove(dominoCube);
    }
	else if(gamePhase == 4)
	{
		require(entry.authorizedUserIds.length == 1);
		require(entry.authorizedUserIds[0] == getTurnOfId());
		require(entry.key == String(DominoCube));
		require(entry.storedByUserId == -1);
		require(entry.value is DominoCube);
		dominoCube=DominoCube.object2DominoCube(entry.value);
		drawCube(dominoCube);
	}
	else if(gamePhase == 5)
	{
		require(serverEntries.length == cubeMax);
		var allDominoCubes:Array=new Array();
		for each(var tempServerEntry:ServerEntry in serverEntries)
		{
			require(tempServerEntry.storedByUserId == -1);
			require(tempServerEntry.value is DominoCube);
			allDominoCubes.push(DominoCube.object2DominoCube(tempServerEntry.value));
		}
		engGame(allDominoCubes);
	}
    //require(entry.storedByUserId==getTurnOfId());
    //require(entry.key==getEntryKey());
    //require(entry.authorizedUserIds == null);
    //var gameMove:GameMove = GameMove.object2GameMove(entry.value);
    //performMove(gameMove);
  } 
}
}
class DominoCube{
	public var upperNumber:int,lowerNumber:int,dominoSide:Boolean,isTakingCube:Boolean;
	function DominoCube(upperNumber:int,lowerNumber:int,dominoSide:Boolean,isTakingCube:Boolean = false)
	{
		this.upperNumber = upperNumber;
		this.lowerNumber = lowerNumber;
		this.dominoSide = dominoSide;
		this.isTakingCube = isTakingCube;
	}
	public static function object2DominoCube(obj:Object):DominoCube {
    	return new DominoCube(obj["upperNumber"], obj["lowerNumber"], obj["dominoSide"], obj["isTakingCube"]);
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