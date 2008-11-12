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
		private var gameLogic:TickTacToeTuturialLogic;
		private var allPlayerIds:Array;
		private var myUserId:int;
		private var userDataArray:Array;
		private var isGameOver:Boolean;
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			(new TickTacToeMove).register();
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.addEventListener(SetNextTurnEvent.SetNextTurnEvent,nextTurn);
			gameLogic.addEventListener(GameOverEvent.GameOverEvent,gameOver);
			userDataArray = new Array();
			super(stageMovieClip);
			doRegisterOnServer()
		}
		private function nextTurn(ev:SetNextTurnEvent):void
		{
			doAllSetTurn(allPlayerIds[ev.nextPlayerId-1],-1);
		}
		private function setTurn():void
		{
			gameLogic.allowMoves(allPlayerIds.indexOf(myUserId) + 1);
		}
		private function gotUserMove(ev:TickTacToeMove):void
		{
			if(!isGameOver)
				doStoreState([UserEntry.create({xPos:ev.xPos,yPos:ev.yPos},ev)])
		}
		
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
		override public function gotUserInfo(userId:int, infoEntries:Array):void
		{
			for each(var infoEntry:InfoEntry in infoEntries)
			{
				if(infoEntry.key == USER_INFO_KEY_avatar_url)
				{
					userDataArray.push(new UserData(infoEntry.value as String,userId))
				}
			}
		}
		override public function gotCustomInfo(infoEntries:Array):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
			gameLogic.LogoUrl = T.custom(CUSTOM_INFO_KEY_logoFullUrl,"") as String;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
		}
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
			setTurn()
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			if(serverEntry.value is TickTacToeMove)
			{
				gameLogic.makeTurn(serverEntry.value as TickTacToeMove);	
			}
			setTurn();
		}
	}
}