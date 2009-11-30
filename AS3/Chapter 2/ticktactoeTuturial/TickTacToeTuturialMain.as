package ticktactoeTuturial
{
	import come2play_as3.api.auto_copied.T;
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic;// An instance of the game's Logic class
		public function TickTacToeTuturialMain()
		{
			super(this);
			gameLogic = new TickTacToeTuturialLogic(this);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.startNewGame(2);//Start a game with 2 players
			doRegisterOnServer();//registers your game on the server
		}
		//gets a TickTacToeMove from the game's logic
		private function gotUserMove(ev:TickTacToeMove):void
		{
			gameLogic.makeTurn(ev);
		}
		/**
		*A function triggered by a server message passing custom info to the game
		*
		*@param infoEntries an Array of InfoEntry elements
		*/
		override public function gotCustomInfo(infoEntries:Array/*InfoEntry*/):void
		{
			gameLogic.stageX = T.custom(CUSTOM_INFO_KEY_gameStageX,0) as int;
			gameLogic.stageY = T.custom(CUSTOM_INFO_KEY_gameStageY,0) as int;
		}
		
	}
}