package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CallCheater extends SerializableClass
	{
		public var isCheater:Boolean
		static public function create(isCheater:Boolean):CallCheater{
			var res:CallCheater = new CallCheater();
			res.isCheater = isCheater;
			return res;
		}
		
	}
}