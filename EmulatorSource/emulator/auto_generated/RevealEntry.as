package emulator.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import emulator.*;
	import emulator.auto_copied.*
	public  class RevealEntry extends SerializableClass {
		public var key:String;
		public var userIds:Array/*int*/;
		public static function create(key:String, userIds:Array/*int*/):RevealEntry {
			var res:RevealEntry = new RevealEntry();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userIds = userIds;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }
	}
}
