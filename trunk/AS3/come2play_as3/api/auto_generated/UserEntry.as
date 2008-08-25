package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class UserEntry extends SerializableClass {
		public var key:String;
		public var value:*;
		public var isSecret:Boolean;
		public static function create(key:String, value:*, isSecret:Boolean):UserEntry {
			var res:UserEntry = new UserEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.value = value;
			res.isSecret = isSecret;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		public function toString():String { return '{UserEntry: ' + getParametersAsString() + '}'; }
	}
}
