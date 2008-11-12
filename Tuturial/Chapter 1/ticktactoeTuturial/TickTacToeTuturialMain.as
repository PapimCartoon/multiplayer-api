package ticktactoeTuturial
{
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic;
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.startNewGame(2);
			super(stageMovieClip);
		}
		private function gotUserMove(ev:TickTacToeMove):void
		{
			gameLogic.makeTurn(ev);
		}
		
	}
}