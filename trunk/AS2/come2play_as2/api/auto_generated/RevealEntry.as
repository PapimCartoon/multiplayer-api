//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.RevealEntry extends SerializableClass {
		public var key:String;
		public var userIds:Array/*int*/;
		public static function create(key:String, userIds:Array/*int*/):RevealEntry {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var res:RevealEntry = new RevealEntry();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.userIds = userIds;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', userIds=' + JSON.stringify(userIds); }
		public function toString():String { return '{RevealEntry: ' + getParametersAsString() + '}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
