package come2play_as3.tictactoe
{
	import flash.display.MovieClip;

	public final class TicTacToe_DocumentClass extends MovieClip
	{
		public function TicTacToe_DocumentClass()
		{
			trace("TicTacToe_DocumentClass");
			new TicTacToe_Main(this);
		}
		
	}
}