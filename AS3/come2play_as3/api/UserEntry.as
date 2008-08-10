package come2play_as3.api {
	import come2play_as3.api.*;
	public final class UserEntry extends Entry {
		public var user_id:int;
		public function UserEntry(key:String, value:Object/*Serializable*/, user_id:int) {
			super(key, value);
			this.user_id = user_id;
		}
		override public function fieldsToString():String {
			return "user_id="+user_id+" "+super.fieldsToString();
		}
		override public function getClassName():String { return "UserEntry"; }
	}
}