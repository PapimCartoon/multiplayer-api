package come2play_as3.pseudoCode
{
	import come2play_as3.api.*;
	/**
	 * The keys in the Match state:
	 * The calculators store in secret memory:
	 * question_<i>:Question
	 * answer_<i>:Answer
	 * Suppose the players are in their 6 question:
	 * currentQuestionNum  
	 * PlayerAnswer_<USER_ID>
	 */
public class PseduTrivia extends SimplifiedClientGameAPI
	{
		public static var questionAmount:int=10;
		public var currentQuestionNum:Number;
		
	override public function gotRequestStateCalculation(serverEntries:Array):void
	{ 
		var serverEntry:ServerEntry=serverEntries[0];
		var newBoardEntries:Array/*ServerEntry*/=new Array();
		/*
		This function runs on a player not playing in the current game
		it gets a random seed and downloads 10 questions and answers (questionAmount)
		and stores an array of server entries containing questions and answers all as secret
		key will be built for
		questions: "question"_Number
		answers : "answer"_Number
		*/
		doAllStoreStateCalculation(newBoardEntries)
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
		doAllRevealState( [new RevealEntry("question_"+currentQuestionNum,null)] );
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
    	doAllRevealState([new RevealEntry("answer_"+currentQuestionNum,null)])	
    }
  }
  private function verifyAnswer(newAnswer:Answer):Boolean
  {
  	for each(var serverEntry:ServerEntry in state)
  	{
  		if(serverEntry.key == "PlayerAnswer_"+newAnswer.playerId)
  		{
  			var value:SerializableClass=SerializableClass.deserialize(serverEntry.value);
  			var oldAnswer:Answer=value as Answer;
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
		var tempSplit:Array=serverEntry.key.split("_");
		if(tempSplit[0]== "PlayerAnswer");
			return SerializableClass.deserialize(serverEntry.value) as Answer;
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
   		doStoreState([new UserEntry("answer_"+currentQuestionNum,oldAnswer,false),
   					  new UserEntry("currentQuestionNum",currentQuestionNum,false)])
   	}
   if(currentQuestionNum>questionAmount) {
		var finishedPlayers:Array/*PlayerMatchOver*/ = []; 
    	for each (var playerId:int in allPlayerIds) {
    		var score:int, potPercentage:int;
        	//set the score and potPercentage for playerId
    		finishedPlayers.push( new PlayerMatchOver(playerId, score, potPercentage) );
     	}
     	doAllEndMatch(finishedPlayers);
   	}
   	else
   		startGame();
   }
  public function userMadeMove(gameMove:Answer):void {
    doStoreState([ new UserEntry("PlayerAnswer"+myUserId, gameMove, false) ]);
  }
  

  override public function gotStateChanged2(serverEntries:Array/*ServerEntry*/):void {
	var entry:ServerEntry = serverEntries[0];
    if (entry.key == "randomSeed") {
    	require(entry.storedByUserId==-1);
    	return;//players don't need the secret mine position seed
    }
	var value:SerializableClass =SerializableClass.deserialize(entry.value);
	    
	if(serverEntries.length == questionAmount*2)
	{
		startGame();
	}
	else if(value is Question)
	{
		var newQuestion:Question=value as Question;
		require(entry.storedByUserId == -1);
		//allow users start answering newQuestion
	}
	else if(value is Answer)
	{
		var newAnswer:Answer=value as Answer;
		if(newAnswer.playerId != -1)
		{
			if(entry.key=="PlayerAnswer_"+entry.storedByUserId)
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
	import come2play_as3.pseudoCode.SerializableClass;
	

class Question extends SerializableClass {
  public var text:String;
}
class Answer extends SerializableClass {
  public var text:String,playerId:int,isCorrect:Boolean;
}
