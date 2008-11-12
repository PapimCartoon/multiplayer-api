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
		private var gameLogic:TickTacToeTuturialLogic;
		private var allPlayerIds:Array;
		private var myUserId:int;
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			(new TickTacToeMove).register();
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			super(stageMovieClip);
			doRegisterOnServer()
		}
		private function gotUserMove(ev:TickTacToeMove):void
		{
			doStoreState([UserEntry.create({xPos:ev.xPos,yPos:ev.yPos},ev)])
		}
		override public function gotCustomInfo(infoEntries:Array):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
		}
		override public function gotMatchStarted(allPlayerIds:Array, finishedPlayerIds:Array, serverEntries:Array):void
		{
			this.allPlayerIds = allPlayerIds;
			gameLogic.startNewGame(allPlayerIds.length);
		}
		override public function gotStateChanged(serverEntries:Array):void
		{
			var serverEntry:ServerEntry = serverEntries[0];
			if(serverEntry.value is TickTacToeMove)
			{
				gameLogic.makeTurn(serverEntry.value as TickTacToeMove);	
			}
		}
	}
}