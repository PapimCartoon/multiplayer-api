package come2play_as3.snake
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerMove extends SerializableClass
	{
		public var xpos:int;
		public var ypos:int;
		public var vector:String;
		public var eating:Boolean;
		public var userId:int
		public var tick:int;
		public function PlayerMove() { super("PlayerMove"); }
		static public function createFromSnakePart(snakePart:SnakePart,vector:String,userId:int):PlayerMove
		{
			var res:PlayerMove = new PlayerMove();
			res.vector = vector;
			res.xpos = snakePart.xpos;
			res.ypos = snakePart.ypos;
			res.userId = userId;
			res.eating = snakePart.eating;
			return res;
		}

	}
}