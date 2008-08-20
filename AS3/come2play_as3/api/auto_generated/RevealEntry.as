package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class RevealEntry extends SerializableClass {
		public var key:String;
		public var userIds:Array/*int*/;
		public static function create(key:String, userIds:Array/*int*/):RevealEntry {
			var res:RevealEntry = new RevealEntry();
			res.key = key;
			res.userIds = userIds;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }
	}
}
