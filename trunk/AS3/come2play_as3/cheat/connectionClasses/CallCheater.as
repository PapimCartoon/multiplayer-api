package come2play_as3.cheat.connectionClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CallCheater extends SerializableClass
	{
		public var callerId:int;
		public var isCheater:Boolean;
		public function CallCheater()
		{
			super("CallCheater");
		}
		static public function create(callerId:int,isCheater:Boolean):CallCheater
		{
			var res:CallCheater = new CallCheater();
			res.callerId =callerId;
			res.isCheater = isCheater;
			return res;
		}
		
	}
}