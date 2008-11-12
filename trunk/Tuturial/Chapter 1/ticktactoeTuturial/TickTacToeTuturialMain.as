package ticktactoeTuturial
{
	import come2play_as3.api.auto_generated.ClientGameAPI;
	
	import flash.display.MovieClip;

	public class TickTacToeTuturialMain extends ClientGameAPI
	{
		private var gameLogic:TickTacToeTuturialLogic; // An instance of the game's Logic class
		public function TickTacToeTuturialMain(stageMovieClip:MovieClip)
		{
			super(stageMovieClip);
			gameLogic = new TickTacToeTuturialLogic(stageMovieClip);
			gameLogic.addEventListener(TickTacToeMove.TickTacToeMoveEvent,gotUserMove);
			gameLogic.startNewGame(2);//Start a game with 2 players
		}
		
		//gets a TickTacToeMove from the game's logic
		private function gotUserMove(ev:TickTacToeMove):void
		{
			gameLogic.makeTurn(ev);
		}
		
	}
}