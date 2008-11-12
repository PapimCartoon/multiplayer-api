package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic;
		private var myUserId:int;
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.startNewGame(2);
			super(stageMovieClip);
			doRegisterOnServer()
		}
		private function gotUserMove(ev:TickTacToeMove):void
		{
			gameLogic.makeTurn(ev);
		}
		override public function gotCustomInfo(infoEntries:Array):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
			myUserId = T.custom(CUSTOM_INFO_KEY_myUserId,null) as int;
		}
		
	}
}