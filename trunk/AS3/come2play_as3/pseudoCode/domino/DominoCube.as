package come2play_as3.pseudoCode.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class DominoCube extends SerializableClass
	{
		public var upperNumber:int,lowerNumber:int,dominoSide:Boolean;
		public function DominoCube() { super("DominoCube"); }
		
		public static function create(upperNumber:int,lowerNumber:int,dominoSide:Boolean):DominoCube
		{
			var res:DominoCube = new DominoCube();
			res.upperNumber = upperNumber;
			res.lowerNumber = lowerNumber;
			res.dominoSide = dominoSide;
			
			return res;
			
		}
		
	}
}