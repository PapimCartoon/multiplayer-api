package come2play_as3.pseudoCode.trivia
{
	import come2play_as3.api.*;
	import come2play_as3.api.auto_copied.*;
	import come2play_as3.api.auto_generated.*;
	import come2play_as3.pseudoCode.SimplifiedClientGameAPI;
	/**
	 * The keys in the Match state:
	 * The calculators store in secret memory:
	 * {type:"question",num:<i>}:Question
	 * {type:"answer",num:<i>}:Answer
	 * Suppose the players are in their 6 question:
	 * currentQuestionNum  
	 * {type:"PlayerAnswer",PlayerAnswer:<USER_ID>}
	 */
public class PseudoTrivia extends SimplifiedClientGameAPI
	{
		public static var questionAmount:int=10;
		public var currentQuestionNum:Number;
	public function PseudoTrivia()
	{
		(new Answer).register();
		(new Question).register();
	}	
	override public function gotRequestStateCalculation(requestId:int,serverEntries:Array):void
	{ 
		var serverEntry:ServerEntry=serverEntries[0];
		var newBoardEntries:Array/*ServerEntry*/=new Array();
		/*
		This function runs on a player not playing in the current game
		it gets a random seed and downloads 10 questions and answers (questionAmount)
		and stores an array of server entries containing questions and answers all as secret server entries.
		*/
		doAllStoreStateCalculation(requestId,newBoardEntries)
	}
	override public function gotMatchStarted2():void 
	{
		// init the logic and the graphics
		currentQuestionNum=0;
		doAllRequestRandomState("randomSeed",true);
		doAllRequestStateCalculation(["randomSeed"]);
	}
	private function startGame():void
	{
		doAllRevealState( [RevealEntry.create({type:"question",num:currentQuestionNum},null)] );
	}
  private function performMove(answer:Answer):void {
    var isQuestionAnswered:Boolean;
    /*
     check if the question was already answered by another player
     remember there can be a case were 2 users send an answer almost simultaneously
     and then the user which answered first gets the square
    */
    if(!isQuestionAnswered)
    {
    	//mark the question as answered and block the option to answer question
    	doAllRevealState([RevealEntry.create({type:"answer",num:currentQuestionNum},null)])	
    }
  }
  private function verifyAnswer(newAnswer:Answer):Boolean
  {
  	for each(var serverEntry:ServerEntry in state)
  	{
  		if((serverEntry.key.type == "PlayerAnswer") && (serverEntry.key.num == newAnswer.playerId))
  		{
  			var oldAnswer:Answer=serverEntry.value as Answer;
  			if((oldAnswer.isCorrect == newAnswer.isCorrect) &&
  			  (oldAnswer.playerId == newAnswer.playerId))
  			  	return true;
  			  else
  			  	return false;
  		}
  	}
  	
  	return false;
  }
  private function findPlayer():Answer
  {
  	for each(var serverEntry:ServerEntry in state)
  	{
		if(serverEntry.key.type== "PlayerAnswer");
			return serverEntry.value as Answer;
  	}
  	return null;
  }
   private function updateGame(oldAnswer:Answer,newAnswer:Answer):void
   {
	if(oldAnswer.text == newAnswer.text)
	{
		//do graphic for oldAnswer.playerId is correct
	}   
	else
	{
		//do graphic for oldAnswer.playerId is wrong
	}
   currentQuestionNum++;
   	if(myUserId == oldAnswer.playerId)
   	{
   		doStoreState([UserEntry.create({type:"answer",num:currentQuestionNum},oldAnswer,false),
   					  UserEntry.create("currentQuestionNum",currentQuestionNum,false)])
   	}
   if(currentQuestionNum>questionAmount) {
		var finishedPlayers:Array/*PlayerMatchOver*/ = []; 
    	for each (var playerId:int in allPlayerIds) {
    		var score:int, potPercentage:int;
        	//set the score and potPercentage for playerId
    		finishedPlayers.push( PlayerMatchOver.create(playerId, score, potPercentage) );
     	}
     	doAllEndMatch(finishedPlayers);
   	}
   	else
   		startGame();
   }
  public function userMadeMove(gameMove:Answer):void {
    doStoreState([ UserEntry.create({type:"PlayerAnswer",PlayerAnswer:myUserId}, gameMove, false) ]);
  }
  

  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	var serverEntry:ServerEntry = serverEntries[0];
    if (serverEntry.key == "randomSeed") {
    	require(serverEntry.storedByUserId==-1);
    	return;//players don't need the secret mine position seed
    }
	if(serverEntries.length == questionAmount*2)
	{
		startGame();
	}
	else if(serverEntry.value is Question)
	{
		var newQuestion:Question=serverEntry.value as Question;
		require(serverEntry.storedByUserId == -1);
		//allow users start answering newQuestion
	}
	else if(serverEntry.value is Answer)
	{
		var newAnswer:Answer=serverEntry.value as Answer;
		if(newAnswer.playerId != -1)
		{
			if ((serverEntry.key.type=="PlayerAnswer") && (serverEntry.storedByUserId == serverEntry.key.playerId))
				performMove(newAnswer);
			else
			{
				require(verifyAnswer(newAnswer));
			}
		}
		else
		{
			var oldAnswer:Answer = findPlayer();
			updateGame(oldAnswer,newAnswer);
			var entry2:ServerEntry=serverEntries[1];
			require(entry2.value == currentQuestionNum);
		}
	}
    }
    
 }
}

