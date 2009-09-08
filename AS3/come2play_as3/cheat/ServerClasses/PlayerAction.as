package come2play_as3.cheat.ServerClasses
{
	import come2play_as3.api.auto_copied.SerializableClass;

	public class PlayerAction extends SerializableClass
	{
		static public const PUT_HIDDEN:String = "PutHidden"
		static public const PUT_FIRST:String = "PutFirst"
		static public const CALL_CHEAT:String = "CallCheat"
		public var userId:int
		public var actionType:String
		static public function create(userId:int,actionType:String):PlayerAction{
			var res:PlayerAction = new PlayerAction();
			res.userId = userId;
			res.actionType = actionType;
			return res;
		}
		
	}
}