package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	
public class PseduBackgammon extends SimplifiedClientGameAPI {
  public var turnNumber:int;
  public var isDicePhase:Boolean;
  
  public function getTurnOfId():int {
    return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
  }
  public function isMyTurn():Boolean {
    return getTurnOfId()==myUserId;
  }
  public function gameMove2UserEntry(gameMoves:GameMove):Array/*UserEntry*/
  {
  //A function that takes a GameMove object and extrapolates the changes to the game state
  return [];
  }
      	
  public function startMove(randomSeed:int):void {
    doAllSetTurn(getTurnOfId(), -1);
    if (isMyTurn()) {
    	var dice:Dice=new Dice(randomSeed);
		var isAbleToMove:Boolean;// check if the player has a vaild move
		if(isAbleToMove)
		{
		// allow the player to select his game moves (game pices current location and new location)
  		}
    }
  }  
  public function startTurn():void
  {
  	isDicePhase=true;
  	doAllRequestRandomState("randomSeed",false);
  }
  public function performMove(gameMoves:Array):void {
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
        finishedPlayers.push(new PlayerMatchOver(playerId, score, potPercentage) );
      }
      doAllEndMatch(finishedPlayers);
    }
  }
  public function userMadeHisMove(gameMoves:Array/*GameMove*/):void {
  	var userEntries:Array/*UserEntry*/ = [];
    for(var i:int=0;i<gameMoves.length;i++)
    {
      var gameMove:GameMove = gameMoves[i];
      userEntries.concat(new UserEntry("gameMove"+i,gameMove,false) );
      userEntries.concat(gameMove2UserEntry(gameMove));  
    }
    doStoreState(userEntries);
    performMove(gameMoves);
  }
  
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    turnNumber = 0;
    startTurn();
  }
  override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void {
    //require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    if(isDicePhase)
    {
   	  require(serverEntries.length == 1);
      require(entry.authorizedUserIds == null);
      require(entry.storedByUserId == -1);
      require(entry.key == "randomSeed");
      isDicePhase=false;
      startMove(int(entry.value));
    }
    else
    { 
      if (entry.storedByUserId==myUserId) return; // already updated my move
      for(var i:int=0;i<serverEntries.length;i+=3)
      {
      	require(entry.key==("gameMove"+i));
      	var otherPlayerGameMoveCalculation:Array=gameMove2UserEntry(serverEntries[i]);
        var GameMoveCalculation:Array=[serverEntries[i+1],serverEntries[i+2]];
      	var compareStateChanges:Boolean;//checks if the moves preformed by the other player correspond to the changes the other player wants to do to the game state
        require(compareStateChanges);
        var gameMoves:Array=[];
        for each(var serverEntry:ServerEntry in serverEntries)
          gameMoves.push(serverEntry.value);
        performMove(gameMoves);
      }	  
    }
  } 
}
}
class GameMove {
  public var pieceCurrentLocation:int, pieceNewLocation:int;
  function GameMove(pieceCurrentLocation:int, pieceNewLocation:int) {
    this.pieceCurrentLocation = pieceCurrentLocation;
    this.pieceNewLocation = pieceNewLocation;
  }
  public static function object2GameMove(obj:Object):GameMove {
    return new GameMove(obj["pieceCurrentLocation"], obj["pieceNewLocation"]);
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