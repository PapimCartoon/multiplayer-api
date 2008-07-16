package come2play_as3.tictactoe
{
import come2play_as3.api.*;

import flash.utils.setTimeout;
	
public final class TicTacToe_SinglePlayerTest
{
	private var tictactoe:TicTacToe_graphic;

	public function TicTacToe_SinglePlayerTest(tictactoe:TicTacToe_graphic) {
		trace("Creating TicTacToe_SinglePlayerTest");
		this.tictactoe = tictactoe;
		tictactoe.addEventListener(GameOverEvent.GAME_OVER_EVENT,gameOver);
		startGame();
	}
	private function startGame():void {
		var match_state:Array/*UserEntry*/ = []; // empty game (not loading a game)
		if (false) {
			// loading a saved game
			match_state = 
				[ 
					new UserEntry("1",[0,0],42),
					new UserEntry("2",[1,1],42), 
					new UserEntry("3",[1,0],42)
				];			
		}
		tictactoe.got_match_started([42],42, match_state);		
	}
	private function gameOver(event:GameOverEvent):void {
		trace("Game is OVER!!! event="+event);
		trace("Starting a new game in 2 seconds");
		setTimeout(startGame, 2000);
	}
}
}