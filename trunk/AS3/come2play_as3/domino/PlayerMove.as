package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerMove extends SerializableClass
	{
		public var sideToPutOn:String;
		public var partConnecting:String;
		public var dominoCube:DominoCube;
		public var playerId:int;
		public var keyToVerefy:int;
		public static const RIGHT:String ="Right";
		public static const LEFT:String ="Left";
		public static const UP:String ="Up";
		public static const DOWN:String ="Down";
		public static const MIDDLE:String ="Middle";
		public function PlayerMove() { super("PlayerMove"); }
		public static function create(sideToPutOn:String,partConnecting:String,dominoCube:PlayerDominoCube,playerId:int):PlayerMove
		{
			var res:PlayerMove = new PlayerMove();
			if(dominoCube !=null)
			{
				res.dominoCube = DominoCube.create(dominoCube.upperNum,dominoCube.lowerNum);
				res.keyToVerefy = dominoCube.key;
			}
			res.partConnecting = partConnecting;
			res.sideToPutOn = sideToPutOn;
			res.playerId = playerId;
			
			return res;
		}
		public function get upperNum():int
		{
			return dominoCube.upperNum;
		}
		public function get lowerNum():int
		{
			return dominoCube.lowerNum;
		}
	}
}