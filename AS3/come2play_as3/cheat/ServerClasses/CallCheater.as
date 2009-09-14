package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CallCheater extends SerializableClass
	{
		public var isCheater:Boolean
		public var callingUser:int
		static public function create(isCheater:Boolean,callingUser:int):CallCheater{
			var res:CallCheater = new CallCheater();
			res.isCheater = isCheater;
			res.callingUser = callingUser;
			return res;
		}
		
	}
}