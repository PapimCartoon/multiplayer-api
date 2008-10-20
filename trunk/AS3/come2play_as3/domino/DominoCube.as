package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class DominoCube extends SerializableClass
	{
		public var upperNum:Number;
		public var lowerNum:Number;
		public function DominoCube() { super("DominoCube"); }
		public static function create(upperNum:Number,lowerNum:Number):DominoCube
		{
			var res:DominoCube = new DominoCube();
			res.lowerNum = lowerNum;
			res.upperNum = upperNum;
			return res;
		}
		public function get right():int{return upperNum;}
		public function get left():int{return lowerNum;}
	}
}