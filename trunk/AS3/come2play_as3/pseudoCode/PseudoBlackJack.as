package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_generated.*;
	public class PseudoBlackJack extends SimplifiedClientGameAPI
	{
 public var turnNumber:int;
 public var currentCard:int;
 public var gamePhase:int;
 public static var deckCount:int=7;
 public var allPlayersAndDelear:Array;
  
  public function getTurnOfId():int {
    return allPlayerIds[turnNumber % allPlayerIds.length]; // round robin turns
  }
  public function getEntryKey():String {
    return ""+turnNumber;
  }
  public function isMyTurn():Boolean {
    return getTurnOfId()==myUserId;
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
  		(UserEntry1.value.value != UserEntry2.value.value ) ||
  		(UserEntry1.visibleToUserIds != UserEntry2.visibleToUserIds ) )
  			return false;
  	}
  	return true;
  } 
  public function initDeck():Array/*UserEntry*/
  {
  	//multiply deckCount by 52 and create linery arranged decks
 	//each card in the deck will be turned into a UserEntry
  	return []
  }
  public function startGame():void
  {
    if (isMyTurn()) {
      doStoreState(initDeck());
      var allCardKeys:Array=new Array();
      for(var i:int=0;i<(deckCount*7);i++)
        allCardKeys.push(String(i));
      doAllShuffleState(allCardKeys);
      var revealCards:Array=new Array();
      for(i=0;i<allPlayersAndDelear.length;i++)
      {
      	revealCards.push(RevealEntry.create(String(i*2),allPlayersAndDelear));
      	revealCards.push(RevealEntry.create(String(i*2+1),[allPlayersAndDelear[i]]));
      }
      doAllRevealState(revealCards);
      gamePhase = 1;
    }	
  }
   public function buildHand(card1:Card,card2:Card,playerID:int):void
   {
   	if(playerID == myUserId)
   	{
   		//graphicly show both your cards
   	}
   	else
   	{
   		//show card2 as playerID's card
   		//playerID -1 means its the dealer
   	}
   }
   public function startMove():void {
    doAllSetTurn(getTurnOfId(), -1);
    if (isMyTurn()) {
      // allow the player to select his game move (hit or stand)
    }
  } 
  public function performMove(gameMove:Card):void {
    // update the logic and the graphics
    turnNumber++; // advance the turn
    var isGameOver:Boolean;
    //checks if the game is over
    if (!isGameOver) {
      startMove();
    } else {
      var finishedPlayers:Array/*PlayerMatchOver*/ = [];
      for each (var playerId:int in allPlayerIds) {
        var score:int, potPercentage:int;
        // set the score and potPercentage for playerId
        finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
      }
      doAllEndMatch(finishedPlayers);
    }
  }
  public function userMadeHisMove(gameMove:String):void {
    doStoreState([ UserEntry.create(getEntryKey(), gameMove, false) ]);
    //performMove(gameMove);
  }
  
  override public function gotMatchStarted2():void {
    // init the logic and the graphics
    allPlayersAndDelear =new Array();
    allPlayersAndDelear.concat(allPlayersAndDelear);
    allPlayersAndDelear.push(-1);
    turnNumber = 0;
    currentCard = 0;
    gamePhase = 0;
 	startGame();
  }
  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
  	
  	var entry:ServerEntry = serverEntries[0];
    if (entry.storedByUserId==myUserId) return; // already updated my move
    if(gamePhase == 0)
    {
    	require(serverEntries.length == (deckCount*52))
    	require(compareServerEntryArrays(serverEntries,initDeck()));
    	var allCardKeys:Array=new Array();
        for(var i:int=0;i<(deckCount*7);i++)
          allCardKeys.push(String(i));
        doAllShuffleState(allCardKeys);
        var revealCards:Array=new Array();
        for(i=0;i<allPlayersAndDelear.length;i++)
        {
      	  revealCards.push(RevealEntry.create(String(i*2),allPlayersAndDelear));
      	  revealCards.push(RevealEntry.create(String(i*2+1),[allPlayersAndDelear[i]]));
        }
        doAllRevealState(revealCards);
        gamePhase = 1;
    }
    else if(gamePhase == 1)
    {
      require(serverEntries.length == (allPlayersAndDelear.length * 2));
      for(i=0;i<serverEntries.length;i++)
      {
      	buildHand(serverEntries[i*2].value,serverEntries[i*2+1].value,serverEntries[i*2+1].visibleToUserIds[0])
      }
      gamePhase = 2;
      startMove();
    }
    else if(gamePhase == 2)
    {
    	
    }
   /*
    require(serverEntries.length==1);
    var entry:ServerEntry = serverEntries[0];
    
    require(entry.storedByUserId==getTurnOfId());
    require(entry.key==getEntryKey());
    require(entry.visibleToUserIds == null);
    //var gameMove:GameMove = GameMove.object2GameMove(entry.value);
    //performMove(gameMove);
    */
  } 
}
}

class Card {
  public var value:int;
  function Card(value:int) {
    this.value = value;
  }
  public static function object2Card(obj:Object):Card {
    return new Card(obj["value"]);
  }     
}