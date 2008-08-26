package come2play_as3.minesweeper
{
	import come2play_as3.api.auto_copied.SerializableClass;
	
	public class PlayerMove extends SerializableClass
	{
		public var xPos:int;
		public var yPos:int;
		public var isMine:Boolean;
		public var takingPlayer:int;

	}
}