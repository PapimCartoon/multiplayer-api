package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerMove extends SerializableClass
	{
		public var key:String;
		public var isRight:Boolean;
		public var dominoCube:DominoCube;
		public var playerId:int;
		
		public static function create(key:String,isRight:Boolean,dominoCube:DominoCube,playerId:int):PlayerMove
		{
			var res:PlayerMove = new PlayerMove();
			res.dominoCube = dominoCube;
			res.key = key;
			res.isRight = isRight;
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