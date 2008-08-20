package come2play_as3.api.auto_generated {
//Do not change the code below because this class was generated automatically!

	import flash.display.*;	import flash.utils.*;
	import come2play_as3.util.*;
	import come2play_as3.api.*
	import come2play_as3.api.auto_copied.*
	public  class InfoEntry extends SerializableClass {
		public var key:String;
		public var value:Object/*Serializable*/;
		public static function create(key:String, value:Object/*Serializable*/):InfoEntry {
			var res:InfoEntry = new InfoEntry();
			res.key = key;
			res.value = value;
			return res;
		}
		public function getParametersAsString():String { return 'key=' + JSON.stringify(key)+', value=' + JSON.stringify(value); }
		public function toString():String { return '{InfoEntry: ' + getParametersAsString() + '}'; }
	}
}
