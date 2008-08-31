package come2play_as3.domino
{
	import flash.display.MovieClip;
	
	public class Domino_Logic
	{
		private var domino_MainPointer:Domino_Main;
		private var graphics:MovieClip;
		
		public function Domino_Logic(domino_MainPointer:Domino_Main,graphics:MovieClip)
		{
			this.graphics = graphics;
			this.domino_MainPointer = domino_MainPointer;
		}

	}
}