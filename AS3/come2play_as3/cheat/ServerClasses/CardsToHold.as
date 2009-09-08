package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class CardsToHold extends SerializableClass
	{
		public var keys:Array/*CardKey*/;
		public var declaredValue:int;
		static public function create(keys:Array/*CardKey*/,declaredValue:int):CardsToHold{
			var res:CardsToHold = new CardsToHold();
			res.declaredValue = declaredValue
			res.keys = keys;
			return res;
		}
		
	}
}