	import come2play_as2.api.*;
import come2play_as2.api.*;
	class come2play_as2.api.Entry {
		public var key:String;
		public var value:Object/*Serializable*/;
		public var secret_level:EnumSecretLevel; // see SecureAPI documentation
		public function Entry(key:String, value:Object/*Serializable*/) {
			this.key = key;
			this.value = value;
			this.secret_level = EnumSecretLevel.PUBLIC;
		}
		public function fieldsToString():String {
			return "key="+key+" value="+value+(secret_level.is_PUBLIC() ? "" : " secret_level="+secret_level);
		}
		public function getClassName():String { return "Entry"; }
		public function toString():String {
			return "["+getClassName()+": "+fieldsToString()+"]";
		}
	}
