package come2play_as3.domino
{
	import come2play_as3.domino.DominoCube;
	
	public class PlayerDominoCube
	{
		public var upperNum:Number;
		public var lowerNum:Number;
		public var key:int;
		public function PlayerDominoCube(dominoCube:DominoCube,key:int)
		{
			lowerNum = dominoCube.lowerNum;
			upperNum = dominoCube.upperNum;
			this.key = key;
		}

	}
}