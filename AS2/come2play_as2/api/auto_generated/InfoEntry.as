//Do not change the code below because this class was generated automatically!

	import come2play_as2.api.*
	import come2play_as2.api.auto_copied.*
import come2play_as2.api.auto_generated.*;
	class come2play_as2.api.auto_generated.InfoEntry extends SerializableClass {
		public var key:String;
		public var value:Object/*Serializable*/;
		public static function create(key:String, value:Object/*Serializable*/):InfoEntry {

// This is a AUTOMATICALLY GENERATED! Do not change!

			var res:InfoEntry = new InfoEntry();
			res.key = key;

// This is a AUTOMATICALLY GENERATED! Do not change!

			res.value = value;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value); }
		public function toString():String { return '{InfoEntry: ' + getParametersAsString() + '}'; }

// This is a AUTOMATICALLY GENERATED! Do not change!

	}
