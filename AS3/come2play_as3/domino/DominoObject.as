package come2play_as3.domino
{
	public class DominoObject
	{
		public var dominoCube:DominoCube;
		public var key:String;
		public function DominoObject(dominoCube:DominoCube,key:String)
		{
			this.dominoCube = dominoCube;
			this.key = key;
		}
		public function get upperNum():int
		{return dominoCube.upperNum;}
		public function get lowerNum():int
		{return dominoCube.lowerNum;}
		public function get right():int
		{return dominoCube.upperNum;}
		public function get left():int{return dominoCube.lowerNum;}

	}
}