package come2play_as3.tictactoe
{
	import flash.display.MovieClip;

	public final class TictactoeDocumentClass extends MovieClip
	{
		public function TictactoeDocumentClass()
		{
			trace("TictactoeDocumentClass");
			new TictactoeMain(this);
		}
		
	}
}