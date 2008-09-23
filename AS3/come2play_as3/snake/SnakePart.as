package come2play_as3.snake
{
	
	public class SnakePart
	{
		public var xpos:int;
		public var ypos:int;
		public var eating:Boolean;
		static public function create(xpos:int,ypos:int,eating:Boolean):SnakePart
		{
			var res:SnakePart = new SnakePart();
			res.xpos = xpos;
			res.ypos = ypos;
			res.eating = eating;
			return res;
		}

	}
}