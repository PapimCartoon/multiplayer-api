package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	import come2play_as3.api.auto_generated.InfoEntry;
	import come2play_as3.api.auto_generated.PlayerMatchOver;
	import come2play_as3.api.auto_generated.ServerEntry;
	import come2play_as3.api.auto_generated.UserEntry;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic; // An instance of the game's Logic class
		private var allPlayerIds:Array/*int*/; // An array containing all the user Ids
		private var myUserId:int;//the id of the current user
		private var isGameOver:Boolean;//is the game in progress
		private var userDataArray:Array/*UserData*/;//an array of user data
		private var graphics:MovieClip;//the movieClip on which the game is placed
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			super(stageMovieClip);
			(new TickTacToeMove).register();// registers a serializable class
			graphics = stageMovieClip;
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.addEventListener(SetNextTurnEvent.SetNextTurnEvent,nextTurn);
			gameLogic.addEventListener(GameOverEvent.GameOverEvent,gameOver);
			userDataArray = new Array();
			doRegisterOnServer()//registers your game on the server
		}
		/**
		*Sets the next playe'r turn on the server
		*/
		private function nextTurn(ev:SetNextTurnEvent):void
		{
			doAllSetTurn(allPlayerIds[ev.nextPlayerId-1],-1);
		}
		/**
		*Sets a palyer's turn
		*/
		private function setTurn():void
		{
			gameLogic.allowMoves(allPlayerIds.indexOf(myUserId) + 1);
		}
		/**
		*Gets a TickTacToeMove from the game's logic
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		private function gotUserMove(ev:TickTacToeMove):void
		{
			if(!isGameOver)
				doStoreState([UserEntry.create({xPos:ev.xPos,yPos:ev.yPos},ev)])
		}
		/**
		*Gets a GameOverEvent from the game's logic
		*
		*@param ev a GameOverEvent instance
		*/
		private function gameOver(ev:GameOverEvent):void
		{
			isGameOver = true;
			var finishedPlayers:Array = new Array();
			var playerMatchOver:PlayerMatchOver;
			for each(var userId:int in allPlayerIds)
			{
				if(userId == ev.winingPlayer)
					playerMatchOver= PlayerMatchOver.create(userId,100,100)
				else
					playerMatchOver= PlayerMatchOver.create(userId,0,0);
				finishedPlayers.push(playerMatchOver)
			}
			
			doAllEndMatch(finishedPlayers);
		}
		/**
		*if the image did not cache successfully,it removes it from the loading
		*
		*@param loaded was the image cached successfully
		*/
		private function imageLoaded(loaded:Boolean):void
		{
			if(!loaded)
			{
				gameLogic.LogoUrl = "";
				userDataArray = new Array();
			}
		}
		/**
		*A function triggered by a server message passing custom info to the game
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		override public function gotUserInfo(userId:int, infoEntries:Array):void
		{
			for each(var infoEntry:InfoEntry in infoEntries)
			{
				if(infoEntry.key == USER_INFO_KEY_avatar_url)
				{
					cacheImage(infoEntry.value as String,graphics,imageLoaded);
					userDataArray.push(new UserData(infoEntry.value as String,userId))
				}
			}
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
			gameLogic.stageWidth = T.custom(CUSTOM_INFO_KEY_gameWidth,0) as int;
			gameLogic.stageHeight = T.custom(CUSTOM_INFO_KEY_gameHeight,0) as int;
			gameLogic.LogoUrl = T.custom(CUSTOM_INFO_KEY_logoFullUrl,"") as String;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
			cacheImage(T.custom(CUSTOM_INFO_KEY_logoFullUrl,"") as String,graphics,imageLoaded);
			
		}
		/**
		*A function triggered by a server message calling a begining of a game or a loding of a game
		*
		*@param allPlayerIds an Array of all the player ids
		*@param finishedPlayerIds an Array of all the finished player ids
		*@param serverEntries an Array of ServerEntry elements in case of a load
		*/
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			isGameOver = false;
			this.allPlayerIds = allPlayerIds;
			var userAvatars:Array = new Array();
			for each(var userData:UserData in userDataArray)
			{
				userAvatars[allPlayerIds.indexOf(userData.userId)] = userData.avatarUrl;
			}
			gameLogic.startNewGame(allPlayerIds.length,userAvatars);
			for each(var serverEntry:ServerEntry in serverEntries)
			{
				if(serverEntry.value is TickTacToeMove)
				{
					gameLogic.makeTurn(serverEntry.value as TickTacToeMove);
				}	
			}
			setTurn()
		}
		/**
		*A function triggered by a server message called by a doStoreState function 
		*
		*@param serverEntries an Array of ServerEntry elements recived
		*/
		override public function gotStateChanged(serverEntries:Array/*ServerEntry*/):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			var gameMove:TickTacToeMove;
			if(serverEntry.value is TickTacToeMove)
			{
				gameMove = serverEntry.value as TickTacToeMove;
				if ((gameMove.xPos !=serverEntry.key.xPos) || (gameMove.yPos !=serverEntry.key.yPos))
					throw new Error("Key does not match the value");
				gameLogic.makeTurn(gameMove);	
			}
			else
				throw new Error("only TickTacToeMove is a legal value in this game");
		}
	}
}