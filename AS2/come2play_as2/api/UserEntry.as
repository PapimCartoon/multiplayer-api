	import come2play_as2.api.*;
import come2play_as2.api.*;
	class come2play_as2.api.UserEntry extends Entry {
		public var user_id:Number;
		public function UserEntry(key:String, value:Object/*Serializable*/, user_id:Number) {
			super(key, value);
			this.user_id = user_id;
		}
		/*override*/ public function toString():String {
			return "UserEntry: user_id="+user_id+" key="+key+" value="+value;
		}
	}
