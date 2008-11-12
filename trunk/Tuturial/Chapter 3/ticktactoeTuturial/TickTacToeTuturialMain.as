package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.AS3_vs_AS2;
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic; // An instance of the game's Logic class
		private var allPlayerIds:Array/*int*/; // An array containing all the user Ids
		private var myUserId:int;//the id of the current user
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			super(stageMovieClip);
			(new TickTacToeMove).register();// registers a serializable class
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			doRegisterOnServer();//registers your game on the server
		}
		/**
		*Gets a TickTacToeMove from the game's logic
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		private function gotUserMove(ev:TickTacToeMove):void
		{
			doStoreState([UserEntry.create({xPos:ev.xPos,yPos:ev.yPos},ev)]);//send a move to the server
		}
		/**
		*A function triggered by a server message passing custom info to the game
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		override public function gotCustomInfo(infoEntries:Array):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
		}
		/**
		*A function triggered by a server message calling a begining of a game
		*
		*@param allPlayerIds an Array of all the player ids
		*@param finishedPlayerIds an Array of all the finished player ids
		*@param serverEntries an Array of ServerEntry elements in case of a load
		*/
		override public function gotMatchStarted(allPlayerIds:Array/*int*/, finishedPlayerIds:Array/*int*/, serverEntries:Array/*ServerEntry*/):void
		{
			this.allPlayerIds = allPlayerIds;
			gameLogic.startNewGame(allPlayerIds.length)//start a new game with an amount of players corresponding to the players connected to the game;
		}
		/**
		*A function triggered by a server message called by a doStoreState function 
		*
		*@param serverEntries an Array of ServerEntry elements recived
		*/
		override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			if(serverEntry.value is TickTacToeMove)
			{
				gameLogic.makeTurn(serverEntry.value as TickTacToeMove);	
			}
		}
	}
}