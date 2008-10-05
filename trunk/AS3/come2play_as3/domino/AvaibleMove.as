package come2play_as3.domino
{
	public class AvaibleMove
	{
		public var partNum:int;
		public var isRight:Boolean
		public var isLeft:Boolean
		public var dominoCube:PlayerDominoCube;
		public function AvaibleMove(partNum:int,dominoCube:PlayerDominoCube,isRight:Boolean,isLeft:Boolean)
		{
			this.partNum = partNum;
			this.isRight = isRight;
			this.isLeft = isLeft;
			this.dominoCube = dominoCube;
		}
		public function toString():String
		{
			return partNum+" : Right = "+isRight+", Left = "+isLeft+", Domino : "+dominoCube.toString();
		}

	}
}