package come2play_as3.api {
	import come2play_as3.api.*;
	public class Entry {
		public var key:String;
		public var value:Object/*Serializable*/;
		public function Entry(key:String, value:Object/*Serializable*/) {
			this.key = key;
			this.value = value;
		}
		public function toString():String {
			return "Entry: key="+key+" value="+value;
		}
	}
}