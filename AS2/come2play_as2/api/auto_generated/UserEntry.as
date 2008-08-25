//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.UserEntry extends SerializableClass {
		public var key:String;
		public var value/*any type*/;
		public var isSecret:Boolean;

// This is a AUTOMATICALLY GENERATED! Do not change!

		public static function create(key:String, value/*any type*/, isSecret:Boolean):UserEntry {
			var res:UserEntry = new UserEntry();

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.key = key;
			res.value = value;
			res.isSecret = isSecret;
			return res;
		}

// This is a AUTOMATICALLY GENERATED! Do not change!

		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value)+', isSecret=' + JSON.stringify(isSecret); }
		public function toString():String { return '{UserEntry: ' + getParametersAsString() + '}'; }
	}
