package come2play_as3.api {
	import come2play_as3.api.*;
	public final class RevealEntry {
		public var key:String;
		public var user_id:int; 
		public function RevealEntry(key:String, user_id:int) {
			this.key = key;
			this.user_id = user_id;
		}
		public function toString():String {
			return "[RevealEntry: key="+key+" user_id="+user_id+"]";
		}
	}
}