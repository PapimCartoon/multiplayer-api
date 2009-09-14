package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CardsToHold extends SerializableClass
	{
		public var keys:Array/*CardKey*/;
		public var declaredValue:int;
		public var cheatingUser:int
		public var callingUser:int
		static public function create(keys:Array/*CardKey*/,declaredValue:int,cheatingUser:int,callingUser:int):CardsToHold{
			var res:CardsToHold = new CardsToHold();
			res.callingUser = callingUser;
			res.cheatingUser = cheatingUser;
			if(declaredValue == 14){
				res.declaredValue = 1
			}else if(declaredValue == 0){
				res.declaredValue = 13
			}else{
				res.declaredValue = declaredValue
			}
			res.keys = keys;
			return res;
		}
		
	}
}