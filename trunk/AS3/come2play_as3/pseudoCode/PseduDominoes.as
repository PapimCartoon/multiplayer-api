package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	public class PseduDominoes extends SimplifiedClientGameAPI
    {
  public var turnNumber:int;
  public var gamePhase:int;
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
  public function compareUserEntryArrays(arr1:Array,arr2:Array):Boolean
  {
  	var UserEntry1:UserEntry;
  	var UserEntry2:UserEntry;
  	for(var i:int=0;i<arr1.length;i++)
  	{
  		UserEntry1=arr1[i];
  		UserEntry2=arr2[i];
  		if((UserEntry1.key != UserEntry2.key ) || 
  		(UserEntry1.value.upperNumber != UserEntry2.value.upperNumber ) ||
  		(UserEntry1.value.lowerNumber != UserEntry2.value.lowerNumber ) )
  			return false;
  	}
  	return true;
  }
  public function userMadeHisMove(gameMove:GameMove):void {
    doStoreState([ new UserEntry(getEntryKey(), gameMove, false) ]);
    performMove(gameMove);
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
    if (entry.storedByUserId == myUserId) return; 
    if(gamePhase == 0)
    {
      for each(var tempEntry:ServerEntry in serverEntries)
      	require(tempEntry.authorizedUserIds == null);
      var myDominoDeck:Array=placeDominos();
      var rivalDominoDeck:Array=serverEntries;
      require(myDominoDeck.length==rivalDominoDeck.length);
      require(compareUserEntryArrays(myDominoDeck,rivalDominoDeck));
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
    	require(serverEntries.length == 21);
    	for each(var serverEntry:ServerEntry in serverEntries)
    	{
    	  require(serverEntry.storedByUserId == -1);
    	  if(serverEntry.authorizedUserIds[0] == myUserId)
    	  	{
    	  		//add Domino to your board graphicly 
    	  	}
    	}
    	//take the 7 dominoes 
    	gamePhase = 3;
    }
    else if(gamePhase == 3)
    {
      startMove();
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
	public var upperNumber:int,lowerNumber:int;
	function DominoCube(upperNumber:int,lowerNumber:int)
	{
		this.upperNumber = upperNumber;
		this.lowerNumber = lowerNumber;
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