package
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class GuessKey extends SerializableClass
	{
		public var userId:int ;
		static public function create(userId:int):GuessKey
		{
			var res:GuessKey = new GuessKey();
			res.userId = userId;
			return res;
		}
		
	}
}