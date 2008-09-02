package come2play_as3.domino
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class NoMoves extends SerializableClass
	{
		public var  userId:int;
		static public function create(userId:int):NoMoves
		{
			var res:NoMoves =new  NoMoves;
			res.userId = userId;
			return res;
		}
		
	}
}